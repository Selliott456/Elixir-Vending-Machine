defmodule Match_MVPWeb.AddProductLive do
  use Match_MVPWeb, :live_view
  alias Match_MVP.VendingMachine.Product
  alias Match_MVP.Products

  alias Match_MVPWeb.Helpers

  def mount(_params, session, socket) do
    changeset = Products.change_product_registration(%Product{})
    seller_product_list = Products.get_products_by_seller_id(socket.assigns.current_user.id)
    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign(:text_value, "")
      |> Helpers.assign_current_user(session)
      |> Helpers.assign_form(changeset)
      |> assign(:seller_product_list, seller_product_list)

    {:ok, socket}
  end

  def handle_event("validate", %{"params" => product_params} , socket) do
    changeset = Products.change_product_registration(%Product{}, product_params)
    {:noreply, Helpers.assign_form(socket, Map.put(changeset, :action, :validate))}
    {:noreply, socket}
  end

  def handle_event("add_product", %{"params" => product_params}, socket) do
    seller_id = socket.assigns.current_user.id

    case Products.create_product(seller_id, product_params) do
      {:ok, product} ->
        changeset = Products.change_product_registration(%Product{}, product)
        socket =
          socket
          |> assign(trigger_submit: true)
          |> Helpers.assign_form(changeset)
          |> put_flash(:info, "product created!")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->

        socket =
          socket
          |> Helpers.assign_form(changeset)
        {:noreply, socket}
    end
  end
end
