defmodule Match_MVPWeb.ErrorJSONTest do
  use Match_MVPWeb.ConnCase, async: true

  test "renders 404" do
    assert Match_MVPWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert Match_MVPWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
