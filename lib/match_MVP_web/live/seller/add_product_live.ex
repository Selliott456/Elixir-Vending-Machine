defmodule Match_MVPWeb.AddProductLive do
  use Match_MVPWeb, :live_view
  alias Match_MVP.VendingMachine.Product
  alias Match_MVP.Products

  alias Match_MVPWeb.Helpers

  def mount(_params, session, socket) do
    changeset = Products.change_product_registration(%Product{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
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
end
