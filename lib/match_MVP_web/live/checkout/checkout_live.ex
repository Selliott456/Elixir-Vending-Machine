defmodule Match_MVPWeb.CheckoutLive do
  use Match_MVPWeb, :live_view

  alias Match_MVP.Accounts

  def mount(_params, session, socket) do
    # add the total in the basket
    # subtract the total from user deposit, keeping remainder
    # calculate change based on coins available
    # update product amount
    socket =
      socket
      |> assign_current_user(session)
      # |> assign_basket_total()
      # |> assign_remaining_balance()
      # |> calculate_change()
      # |> update_product_list()

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
