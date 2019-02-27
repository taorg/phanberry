defmodule Firmware.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.Project.config()[:target]
  alias Firmware.EventBus.Supervisors.Joystick, as: JoystickSupervisor
  alias Firmware.EventBus.Workers.JoystickConsummer, as: JoystickListener
  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    # Start your own worker by calling: Firmware.Worker.start_link(arg1, arg2, arg3)
    children =
      [
        # worker(Firmware.Worker, [arg1, arg2, arg3]),
        supervisor(JoystickSupervisor, [], id: make_ref(), restart: :permanent)
        # supervisor(Firmware.Cuadruped.Controler.Superisor, [], restart: :permanent),
        # supervisor(Nerves.Grove.PCA9685.Tetrapod, [], id: make_ref())
      ] ++ children(@target)

    opts = [strategy: :one_for_one, name: Firmware.Supervisor]
    link = Supervisor.start_link(children, opts)
    # opts = [strategy: :one_for_one, name: Firmware.GPIO1602]
    # Supervisor.start_link(childred(:gpio1602), opts)
    EventBus.subscribe({JoystickListener, ["^jstick_tx_event$", "^jstick_tx_obj$"]})
    link
  end

  # List all child processes to be supervised
  def children("host") do
    [
      # Starts a worker by calling: Firmware.Worker.start_link(arg)
      # {Firmware.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Starts a worker by calling: Firmware.Worker.start_link(arg)
      # {Firmware.Worker, arg},
    ]
  end

  def childred(:gpio1602) do
    import Supervisor.Spec, warn: false
    config = Application.get_env(:firmware, :ex_lcd)
    supervisor(ExLCD, [{ExLCD.GPIO1602, config}])
  end
end
