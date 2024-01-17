defmodule Match_MVPWeb.CheckoutLive do
  use Match_MVPWeb, :live_view

  alias Match_MVP.Accounts

  def mount(_params, session, socket) do
    socket =
      socket
      |> assign_current_user(session)

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

end
