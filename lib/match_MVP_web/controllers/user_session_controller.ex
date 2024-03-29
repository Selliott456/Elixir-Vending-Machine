defmodule Match_MVPWeb.UserSessionController do
  use Match_MVPWeb, :controller

  alias Match_MVP.Accounts
  alias Match_MVPWeb.UserAuth

  def create(conn, %{"_action" => "registered"} = params) do
    create(conn, params, "Account created successfully!")

    conn
    |> redirect(to: ~p"/")
  end

  def create(conn, params) do
    create(conn, params, "Welcome back!")
  end

  defp create(conn, %{"user" => user_params}, info) do
    %{"username" => username, "password" => password} = user_params

    if user = Accounts.get_user_by_username_and_password(username, password) do
      conn
      |> put_flash(:info, info)
      |> UserAuth.log_in_user(user, user_params)
      # |> redirect(to: ~p"/")
    else
      conn
      |> put_flash(:error, "Invalid username or password")
      |> put_flash(:username, String.slice(username, 0, 160))
      |> redirect(to: ~p"/users/log_in")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
    |> redirect(to: ~p"/")
  end
end
