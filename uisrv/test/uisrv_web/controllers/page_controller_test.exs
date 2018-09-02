defmodule UisrvWeb.PageControllerTest do
  use UisrvWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Phanberry"
  end
end
