defmodule Firmware.Cuadruped.Handle_joystick.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    children = [
      {Registry, keys: :unique, name: :joystick_registry},
      worker(Firmware.Cuadruped.Handle_joystick.Fns, [opts])
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  def look_children, do: Supervisor.which_children(__MODULE__)
end
