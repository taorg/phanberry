defmodule Firmware.Cuadruped.Controler.Srvr do
  use GenServer
  require Logger

  def init(opts) do
    state = opts
    InputEvent.enumerate
    Process.sleep(5000)
    [device] = InputEvent.Enumerate.all_devices
    Logger.debug("Device = #{inspect(device)}")
    InputEvent.start_link(device)
    Process.sleep(500)
    recieve_loop()
    {:ok, state}
  end

  def handle_info(:loop, state) do
    recieve_loop()
    {:noreply, state}
  end

  def recieve_loop() do
    Logger.debug("Looking for event")
    receive do
      {:input_event, "/dev/input/event0", event} ->
        process_event(event)
      other ->
        process_event(other)
    end
    Process.send(self(), :loop, [:nosuspend])
  end

  def process_event(event) do
    Logger.debug("I got #{inspect(event)}")
  end
end
