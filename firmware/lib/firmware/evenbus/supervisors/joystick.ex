defmodule Firmware.EventBus.Supervisors.Joystick do
  @moduledoc """
  A supervisor for Joystick
  """

  use Supervisor
  alias Firmware.EventBus.Workers.JoystickConsummer, as: JoystickWorker

  @doc false
  def start_link,
    do: Supervisor.start_link(__MODULE__, [], name: __MODULE__)

  @doc false
  def init([]) do
    children = [
      worker(JoystickWorker, [], id: make_ref(), restart: :permanent),
      supervisor(Firmware.Cuadruped.Controler.Superisor, [{}], id: make_ref(), restart: :permanent)
      # supervisor(Nerves.Grove.PCA9685.Tetrapod, [], id: make_ref(), restart: :permanent)
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]

    supervise(children, opts)
  end
end
