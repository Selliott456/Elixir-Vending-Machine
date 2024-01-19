# defmodule Match_MVPWeb.UserSessionControllerTest do
#   use Match_MVPWeb.ConnCase, async: true

#   import Match_MVP.AccountsFixtures

#   setup do
#     %{user: user_fixture()}
#   end

#   describe "POST /users/log_in" do
#     test "logs the user in", %{conn: conn, user: user} do
#       conn =
#         post(conn, ~p"/users/log_in", %{
#           "user" => %{"username" => user.username, "password" => valid_user_password()}
#         })

#       assert get_session(conn, :user_token)
#       assert redirected_to(conn) == ~p"/"

#       # Now do a logged in request and assert on the menu
#       conn = get(conn, ~p"/")
#       response = html_response(conn, 200)
#       assert response =~ user.username
#       assert response =~ ~p"/users/settings"
#       assert response =~ ~p"/users/log_out"
#     end

#     test "logs the user in with remember me", %{conn: conn, user: user} do
#       conn =
#         post(conn, ~p"/users/log_in", %{
#           "user" => %{
#             "username" => user.username,
#             "password" => valid_user_password(),
#             "remember_me" => "true"
#           }
#         })

#       assert conn.resp_cookies["_match_mvp_web_user_remember_me"]
#       assert redirected_to(conn) == ~p"/"
#     end

#     test "logs the user in with return to", %{conn: conn, user: user} do
#       conn =
#         conn
#         |> init_test_session(user_return_to: "/foo/bar")
#         |> post(~p"/users/log_in", %{
#           "user" => %{
#             "username" => user.username,
#             "password" => valid_user_password()
#           }
#         })

#       assert redirected_to(conn) == "/foo/bar"
#       assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Welcome back!"
#     end

#     test "login following registration", %{conn: conn, user: user} do
#       conn =
#         conn
#         |> post(~p"/users/log_in", %{
#           "_action" => "registered",
#           "user" => %{
#             "username" => user.username,
#             "password" => valid_user_password()
#           }
#         })

#       assert redirected_to(conn) == ~p"/"
#       assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Account created successfully"
#     end

#     test "login following password update", %{conn: conn, user: user} do
#       conn =
#         conn
#         |> post(~p"/users/log_in", %{
#           "_action" => "password_updated",
#           "user" => %{
#             "username" => user.username,
#             "password" => valid_user_password()
#           }
#         })

#       assert redirected_to(conn) == ~p"/users/settings"
#       assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Password updated successfully"
#     end

#     test "redirects to login page with invalid credentials", %{conn: conn} do
#       conn =
#         post(conn, ~p"/users/log_in", %{
#           "user" => %{"username" => "invalid@username.com", "password" => "invalid_password"}
#         })

#       assert Phoenix.Flash.get(conn.assigns.flash, :error) == "Invalid username or password"
#       assert redirected_to(conn) == ~p"/users/log_in"
#     end
#   end

#   describe "DELETE /users/log_out" do
#     test "logs the user out", %{conn: conn, user: user} do
#       conn = conn |> log_in_user(user) |> delete(~p"/users/log_out")
#       assert redirected_to(conn) == ~p"/"
#       refute get_session(conn, :user_token)
#       assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Logged out successfully"
#     end

#     test "succeeds even if the user is not logged in", %{conn: conn} do
#       conn = delete(conn, ~p"/users/log_out")
#       assert redirected_to(conn) == ~p"/"
#       refute get_session(conn, :user_token)
#       assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Logged out successfully"
#     end
#   end
# end
