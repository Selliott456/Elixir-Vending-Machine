defmodule Match_MVPWeb.Helpers do
  import Phoenix.Component

  alias Match_MVP.Accounts


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

  def assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "product")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
