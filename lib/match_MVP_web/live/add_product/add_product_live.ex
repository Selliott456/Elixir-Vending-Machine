defmodule Match_MVPWeb.AddProductLive do
  use Match_MVPWeb, :live_view
  alias Match_MVP.Products.Product
  alias Match_MVP.Products
  alias Match_MVP.Accounts


  def mount(_params, session, socket) do
    changeset = Products.change_product_registration(%Product{})
    username = live_flash(socket.assigns.flash, :username)
    form = to_form(%{"username" => username}, as: "user")

    socket =
      socket
      |> assign_current_user(session)
      |> assign_product()
      |> assign(:changeset, changeset)

      {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end

  def assign_product(socket) do
    socket
    |> assign(:product, %Product{})
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

  def handle_event("save", %{"product" => product_params}, socket) do
    seller_id = socket.assigns.current_user.id
    IO.inspect(product_params)

    case Products.create_product(seller_id, product_params) do
      {:ok, _product} ->
        IO.inspect("PRODUCT CREATED")
        {:noreply,
        socket
        |> put_flash(:info, "Product successfully added")
        |> push_redirect(to: "/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
        socket
        |> put_flash(:error, "BIG SMELLY ERROR")
        |> assign(:changeset, changeset)}
    end
    {:noreply, socket}
  end

  def handle_params(_params, _url, socket) do
    {:noreply,
     socket}
  end

end
