defmodule UisrvWeb.Joystick.JoystickController do
  use UisrvWeb, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end
end
