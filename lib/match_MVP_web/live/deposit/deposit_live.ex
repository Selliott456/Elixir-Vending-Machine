defmodule Match_MVPWeb.DepositLive do
  use Match_MVPWeb, :live_view

  alias Match_MVP.Accounts.User
  alias Match_MVP.Accounts

  def mount(_params, session, socket) do
    changeset = User.update_user_deposit_changeset(%User{}, %{})
    socket =
      socket
      |> assign_current_user(session)
      |> assign_form(changeset)
      |> assign(:deposit, socket.assigns.current_user.deposit)


    {:ok, socket}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "deposit")
    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end

  def handle_event("deposit_coin", %{"deposit" => deposit}, socket) do
    user = socket.assigns.current_user
    total_deposit = calculate_deposit(socket, deposit)
    case Accounts.update_user(user, %{deposit: total_deposit}) do
      %User{} = user ->
        socket =
          socket
          |> assign(:deposit, Float.round(user.deposit, 2))

        {:noreply, socket}
      _ ->
        socket =
          socket
          |> put_flash(:error, "could not add coin")
        {:noreply, socket}
    end
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

  def calculate_deposit(socket, deposit) do
       socket.assigns.current_user.deposit + (String.to_integer(deposit["deposit"])/100)
  end

end
