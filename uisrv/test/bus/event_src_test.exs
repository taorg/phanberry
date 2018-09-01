defmodule Uisrv.Bus.EventSourceTest do
  use ExUnit.Case, async: true
  use EventBus.EventSource
  require Logger
  alias Uisrv.Workers.RaspberrySource

  test "notify" do
    # EventBus.subscribe({Uisrv.Workers.Raspberry, [:rpbrr_msg_rx, :phx_msg_rx]})
    # Wait until listeners subscribed to
    Process.sleep(100)

    for x <- 1..10 do
      msg = %{email: Faker.Internet.email(), name: Faker.Name.name()}
      event = RaspberrySource.fake_rapberry(msg, x)
      # Logger.debug("Event :#{inspect(event)}")
      EventBus.notify(event)
      # Wait until listeners process events
      Process.sleep(300)
    end

    assert true == true
  end
end
