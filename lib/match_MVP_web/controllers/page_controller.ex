defmodule Match_MVPWeb.PageController do
  use Match_MVPWeb, :controller

  def home(conn, _params) do

    redirect(conn, to: ~p"/users/register")
    # render(conn, :home, layout: false)
  end
end
