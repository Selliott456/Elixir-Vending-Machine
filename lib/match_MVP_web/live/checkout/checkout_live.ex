defmodule Match_MVPWeb.CheckoutLive do
  use Match_MVPWeb, :live_view

  alias Match_MVP.Orders
  alias Match_MVP.Accounts
  alias Match_MVP.Accounts.User

  def mount(_params, session, socket) do
    user_order = Orders.get_order_by_user_id(socket.assigns.current_user.id)
    change_due = Float.round(socket.assigns.current_user.deposit - user_order.total_cost, 2)

    socket =
      socket
      |> assign_current_user(session)
      |> assign(:order, user_order)
      |> assign(:change_due, change_due)

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

  def handle_event("make_change", _params, socket) do
    IO.puts("CHANGE BUTTON WORKS")
    {:noreply, socket}
  end

  def handle_event("update_balance", _params, socket) do

    case Accounts.get_user!(socket.assigns.current_user.id) do
      %User{} = user ->
        Accounts.update_user(user, %{deposit: socket.assigns.change_due})

        {:noreply, socket}

    _ -> IO.puts("NO USER")
    {:noreply, socket}
    end


  end
end
