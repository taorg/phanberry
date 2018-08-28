defmodule UisrvWeb.LayoutView do
  use UisrvWeb, :view
  import PhoenixActiveLink
  require Logger

  def is_autenticated?(conn) do
    Logger.debug("Current user: #{inspect(Guardian.Plug.current_resource(conn))}")
    !is_nil(Guardian.Plug.current_resource(conn))
  end

  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end
end
