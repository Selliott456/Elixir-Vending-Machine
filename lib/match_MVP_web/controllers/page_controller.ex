defmodule Match_MVPWeb.PageController do
  use Match_MVPWeb, :controller

  def home(conn, _params) do

    render(conn, :home, layout: false)
  end
end
