defmodule Match_MVPWeb.UserActionsLive do
  use Match_MVPWeb, :live_view
  alias Match_MVP.Orders
  alias Match_MVP.VendingMachine.Product
  alias Match_MVP.Products
  alias Match_MVP.Accounts

  def mount(_params, session, socket) do
    remove_empty_products()
    changeset = Products.change_product_registration(%Product{})
    product_list = Products.list_products()

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign(:product_list, product_list)
      |> assign(:basket, [])
      |> assign(:order_total, 0)
      |> assign_current_user(session)
      |> assign_form(changeset)

    {:ok, socket}
  end

  def assign_current_user(socket, session) do
    case session do
      %{"user_token" => user_token} ->
        assign_new(socket, :current_user, fn ->
          Accounts.get_user_by_session_token(user_token)
        end)

      %{} ->
        assign_new(socket, :current_user, fn -> nil end)
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "product")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end

  def handle_event("add_product", %{"product" => product_params}, socket) do
    seller_id = socket.assigns.current_user.id

    case Products.create_product(seller_id, product_params) do
      {:ok, _product} ->
        changeset = Products.change_product_registration(%Product{}, product_params)

        socket =
          socket
          |> assign_form(Map.put(changeset, :action, :validate))
          |> put_flash(:info, "success")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end

    {:noreply, socket}
  end

  def handle_event("add_to_basket", product, socket) do
    case socket.assigns.basket do
      [] ->
        basket = [product]
        order_total = calculate_order_total(basket)
        {:noreply, socket |> assign(:basket, basket) |> assign(:order_total, order_total)}

      _ ->
        basket = socket.assigns.basket ++ [product]
        order_total = calculate_order_total(basket)
        {:noreply, socket |> assign(:basket, basket) |> assign(:order_total, order_total)}
    end
  end

  def handle_event("purchase", _params, socket) do
    basket = socket.assigns.basket
    create_order(socket)

    Enum.map(basket, fn product ->
      product_id = String.to_integer(product["id"])

      case Products.get_product_by_id!(product_id) do
        %Product{} = product ->
          Products.update_product(product, %{amount_available: product.amount_available - 1})
          {:noreply, socket}

        _ ->
          socket =
            socket
            |> put_flash(:error, "something went wrong")

          {:noreply, socket}
      end
    end)

    {:noreply, socket}
  end

  def calculate_order_total(basket) do
    item_costs = Enum.map(basket, fn item -> String.to_float(item["cost"]) end)
    Float.round(Enum.reduce(item_costs, fn item_cost, acc -> item_cost + acc end), 2)

    # Orders.create_order(socket.assigns.current_user.id, %{basket: basket, total_cost: item_costs, change_due: 12.34})
  end

  def remove_empty_products() do
    all_products = Products.list_products()

    Enum.map(all_products, fn product ->
      case product.amount_available do
        0 -> Products.delete_product(product)
        _ -> nil
      end
    end)
  end

  defp create_order(socket) do
    user_id = socket.assigns.current_user.id
    basket = socket.assigns.basket
    total_cost = socket.assigns.order_total

    Orders.create_order(user_id, %{basket: basket, total_cost: total_cost})
  end
end
