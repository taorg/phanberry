defmodule Firmware.EventBus.Workers.JoystickSource do
  use EventBus.EventSource
  import UUID

  def fake_rapberry(msg, tx_id) do
    id = uuid1()
    topic = :jstick_tx_obj
    # optional
    transaction_id = tx_id
    # optional
    source = "JoystickSource"
    params = %{id: id, topic: topic, transaction_id: transaction_id, source: source}

    EventSource.build params do
      # do some calc in here
      Process.sleep(1)
      # as a result return only the event data
      msg
    end
  end
end
