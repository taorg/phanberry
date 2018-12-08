defmodule Firmware.Cuadruped.Controler.Superisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do

    children = [
      {Registry, keys: :unique, name: :controler_registry},
      worker(Firmware.Cuadruped.Controler.Fns, [opts])
    ]
    Supervisor.init(children, strategy: :one_for_all)
  end

end
