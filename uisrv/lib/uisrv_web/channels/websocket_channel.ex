defmodule UisrvWeb.WebSocketChannel do
  use Phoenix.Channel
  require Logger
  use EventBus.EventSource
  import UUID

  def join("wschannel:joystick", _message, socket) do
    {:ok, socket}
  end

  def join("wschannel:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_jstick_chn_evnt", %{"jstick_event" => evt}, socket) do
    joystic_source(%{jstick_event: evt})
    |>EventBus.notify()
    {:noreply, socket}
  end

  def handle_in("new_jstick_chn_obj", %{"jstick_obj" => obj}, socket) do
    joystic_source(%{jstick_obj: obj})
    |>EventBus.notify()
    {:noreply, socket}
  end

  defp joystic_source(msg, tx_id \\ 0) do
    id = uuid1()
    topic = :jstick_tx_obj
    # optional
    transaction_id = tx_id
    # optional
    source = "JoystickSource"
    params = %{id: id, topic: topic, transaction_id: transaction_id, source: source}

    EventSource.build params do
      # as a result return only the event data
      msg
    end
  end
end
