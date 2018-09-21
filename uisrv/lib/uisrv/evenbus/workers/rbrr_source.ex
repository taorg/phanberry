defmodule Uisrv.EventBus.Workers.RaspberrySource do
  use EventBus.EventSource
  import UUID

  def fake_rapberry(msg, tx_id) do
    id = uuid1()
    topic = :rpbrr_msg_rx
    # optional
    transaction_id = tx_id
    # optional
    source = "RaspberrySource"
    params = %{id: id, topic: topic, transaction_id: transaction_id, source: source}

    EventSource.build params do
      # do some calc in here
      Process.sleep(1)
      # as a result return only the event data
      msg
    end
  end
end
