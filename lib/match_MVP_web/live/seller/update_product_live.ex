defmodule Match_MVPWeb.UpdateProductLive do
  use Match_MVPWeb, :live_view
  alias Match_MVP.VendingMachine.Product
  alias Match_MVP.Products

  alias Match_MVPWeb.Helpers

  def mount(%{"id" => id}, _session, socket) do
      product = get_product(id)
      changeset = Products.change_product_registration(%Product{})

      socket =
        socket
        |> assign(trigger_submit: false, check_errors: false)
        |> assign(:product, product)
        |> assign(:text_value, "")
        |> Helpers.assign_form(changeset)

    {:ok, socket}
  end

  def get_product(id) do
    case Products.get_product_by_id!(id) do
      %Product{} = product ->
            product
        _ ->
          nil
    end
  end

  def handle_event("update_product", %{"params" => product_params}, socket) do
    product = socket.assigns.product

    case Products.update_product(product, product_params) do
      {:ok, _product} ->
        changeset = Products.change_product_registration(%Product{}, product_params)

        socket =
          socket
          |> Helpers.assign_form(Map.put(changeset, :action, :validate))
          |> put_flash(:info, "Product updated")

        {:noreply, socket}

      _ ->
        socket =
          socket
          |> put_flash(:error, "product could not be updated")

        {:noreply, socket}
    end

    {:noreply, socket |> assign(:text_value, nil)}
  end
end
