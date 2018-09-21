defmodule UisrvWeb.WebSocketChannel do
  use Phoenix.Channel
  require Logger

  def join("wschannel:joystick", _message, socket) do
    {:ok, socket}
  end

  def join("wschannel:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_jstick_chn_evnt", %{"jstick_event" => evt}, socket) do
    broadcast!(socket, "new_jstick_chn_evnt", %{jstick_event: evt})
    {:noreply, socket}
  end

  def handle_in("new_jstick_chn_obj", %{"jstick_obj" => obj}, socket) do
    broadcast!(socket, "new_jstick_chn_obj", %{jstick_obj: obj})
    {:noreply, socket}
  end
end
