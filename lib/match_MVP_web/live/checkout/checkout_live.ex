defmodule Match_MVPWeb.CheckoutLive do
  use Match_MVPWeb, :live_view

  alias Match_MVP.Orders
  alias Match_MVP.Accounts
  alias Match_MVP.Accounts.User
  alias Match_MVPWeb.Helpers
  alias Match_MVP.VendingMachine.Product
  alias Match_MVP.Products

  def mount(_params, session, socket) do
    user_order = Orders.get_orders_by_user_id(socket.assigns.current_user.id)
    change_due = Float.round(socket.assigns.current_user.deposit - user_order.total_cost, 2)
    change_in_cents = change_due * 100
    [change_available, leftover] = round_cash(change_in_cents)
    coin_values = get_change(change_available)

    socket =
      socket
      |> Helpers.assign_current_user(session)
      |> assign(:order, user_order)
      |> assign(:change_due, change_due)
      |> assign(:change_available, change_available / 100)
      |> assign(:change_leftover, Float.floor(leftover / 100))
      |> assign(:coin_values, coin_values)

    {:ok, socket}
  end

  def handle_event("make_change", _params, socket) do
    case Accounts.get_user!(socket.assigns.current_user.id) do
      %User{} = user ->
        basket = socket.assigns.order.basket

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

        Accounts.update_user(user, %{deposit: socket.assigns.change_leftover / 100})
        {:noreply, socket}

      _ ->
        socket =
          socket
          |> put_flash(:error, "could not complete purchase")

        {:noreply, socket}
    end

    {:noreply, socket}
  end

  def get_change(amount) do
    coin_values = [100, 50, 20, 10, 5]
    coins = coins(coin_values, amount)

    "Euro: #{Enum.at(coins, 0)}, " <>
      "Fifty cents: #{Enum.at(coins, 1)}, " <>
      "Twenty cents: #{Enum.at(coins, 2)}, " <>
      "ten cents: #{Enum.at(coins, 3)}, " <>
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
    quotient = result |> Kernel.floor()
    remainder = change_due - quotient * 5
    [quotient * 5, remainder * 100]
  end
end
