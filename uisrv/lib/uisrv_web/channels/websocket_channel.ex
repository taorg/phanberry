defmodule UisrvWeb.WebSocketChannel do
  use Phoenix.Channel
  require Logger

  def join("wschannel:joystick", _message, socket) do
    {:ok, socket}
  end

  def join("wschannel:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast!(socket, "new_msg", %{body: body})
    {:noreply, socket}
  end
end
