defmodule Match_MVPWeb.CheckoutLive do
  use Match_MVPWeb, :live_view

  alias Match_MVP.Orders
  alias Match_MVP.Accounts
  alias Match_MVP.Accounts.User

  def mount(_params, session, socket) do
    user_order = Orders.get_order_by_user_id(socket.assigns.current_user.id)
    change_due = Float.round(socket.assigns.current_user.deposit - user_order.total_cost, 2)
    change_in_cents = change_due * 100
    [change_available, leftover] = round_cash(change_in_cents)
    coin_values = get_change(change_available)


    socket =
      socket
      |> assign_current_user(session)
      |> assign(:order, user_order)
      |> assign(:change_due, change_due)
      |> assign(:change_available, change_available/100)
      |> assign(:change_leftover, leftover/100)
      |> assign(:coin_values, coin_values)

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
    case Accounts.get_user!(socket.assigns.current_user.id) do
      %User{} = user ->
        Accounts.update_user(user, %{deposit: 0})
        {:noreply, socket}

      _ -> IO.puts("NO USER")
    end
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

  def get_change(amount) do
    coin_values = [100, 50, 20, 10, 5]
    coins = coins(coin_values, amount)
    "Euro: #{Enum.at(coins, 0)}, "<>
    "Fifty cents: #{Enum.at(coins, 1)}, "<>
    "Twenty cents: #{Enum.at(coins, 2)}, "<>
    "ten cents: #{Enum.at(coins, 3)}, "<>
    "five cents: #{Enum.at(coins, 4)}, "
  end

  def coins([], 0), do: []

  def coins([coin | incoming_coins], amount) when amount < coin do
    number_of_coin = 0
    [number_of_coin | coins(incoming_coins, amount)]
  end

  def coins([coin | incoming_coins], amount) do
    number_of_coin = div(amount, coin)
    remaining_amount = rem(amount, coin)
    [number_of_coin | coins(incoming_coins, remaining_amount)]
  end


  def round_cash(change_due) do
    result = change_due / 5
    quotient = result |> Kernel.floor
    remainder = change_due - (quotient * 5)
    [quotient * 5, remainder * 100]
  end

end
