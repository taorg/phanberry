defmodule Firmware.Cuadruped.Controler.Fns do
  require Logger

  def start_link(opts) do
    GenServer.start_link(Firmware.Cuadruped.Controler.Srvr, opts, name: via_tuple())
  end

  def via_tuple do
    {:via, Registry, {:controler_registry, :controler_server}}
  end
end
