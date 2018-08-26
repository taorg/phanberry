defmodule UisrvWeb.PageController do
  use UisrvWeb, :controller
  alias Uisrv.Model.Accounts
  alias Uisrv.Auth.Guardian

  def index(conn, _params) do
    conn
    |> assign(:users, Accounts.list_users())
    |> assign(:current_user, Guardian.Plug.current_resource(conn))
    |> render("index.html")
  end
end
