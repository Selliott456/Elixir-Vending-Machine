defmodule Match_MVPWeb.DepositLive do
  use Match_MVPWeb, :live_view

  alias Match_MVP.Accounts.User
  alias Match_MVP.Accounts
  alias Match_MVPWeb.Helpers

  def mount(_params, session, socket) do
    changeset = User.update_user_deposit_changeset(%User{}, %{})
    user_deposit = socket.assigns.current_user.deposit
    socket =
      socket
      |> Helpers.assign_current_user(session)
      |> Helpers.assign_form(changeset)
      |> assign(:deposit, user_deposit)

    {:ok, socket}
  end

  def handle_event("deposit_coin", %{"deposit" => deposit}, socket) do
    current_user_balance = socket.assigns.current_user.deposit * 100
    deposit_as_int = String.to_integer(deposit["deposit"])
    total_deposit = (current_user_balance + deposit_as_int) / 100

    case Accounts.update_user(socket.assigns.current_user, %{deposit: total_deposit}) do
      %User{} ->
        socket =
          socket
          |> assign(:deposit, total_deposit)

        {:noreply, socket}

      _ ->
        socket =
          socket
          |> put_flash(:error, "could not add coin")
        {:noreply, socket}
    end
  end

end
