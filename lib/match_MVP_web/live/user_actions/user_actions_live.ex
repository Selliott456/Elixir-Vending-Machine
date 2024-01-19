defmodule Match_MVPWeb.UserActionsLive do
  use Match_MVPWeb, :live_view
  alias Match_MVP.Orders
  alias Match_MVP.VendingMachine.Product
  alias Match_MVP.Products
  alias Match_MVP.Accounts
  alias Match_MVP.Accounts.User

  alias Match_MVPWeb.Helpers

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
      |> assign(:text_value, "")
      |> Helpers.assign_current_user(session)
      |> Helpers.assign_form(changeset)

    {:ok, socket}
  end



  def handle_event("add_product", %{"params" => product_params}, socket) do
    seller_id = socket.assigns.current_user.id

    case Products.create_product(seller_id, product_params) do
      {:ok, _product} ->
        changeset = Products.change_product_registration(%Product{}, product_params)

        socket =
          socket
          |> Helpers.assign_form(Map.put(changeset, :action, :validate))
          |> put_flash(:info, "Product added")

        {:noreply, socket}

      _ ->
        socket =
          socket
          |> put_flash(:error, "product already in stock")

        {:noreply, socket}
    end

    {:noreply, socket |> assign(:text_value, nil)}
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
            |> put_flash(:error, "could not find product")

          {:noreply, socket}
      end
    end)

    {:noreply, socket}
  end

  def handle_event("return_deposit", _params, socket) do
    case Accounts.get_user!(socket.assigns.current_user.id) do
      %User{} = user ->
        Accounts.update_user(user, %{deposit: 0})

        socket =
          socket
          |> redirect(to: ~p"/deposit")

        {:noreply, socket}

      _ ->
        socket =
          socket
          |> put_flash(:error, "No user found")

        {:error, socket}
    end
  end

  def calculate_order_total(basket) do
    item_costs = Enum.map(basket, fn item -> String.to_float(item["cost"]) end)
    Float.round(Enum.reduce(item_costs, fn item_cost, acc -> item_cost + acc end), 2)
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
