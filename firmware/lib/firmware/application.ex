defmodule Firmware.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.Project.config()[:target]

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Firmware.Supervisor]
    Supervisor.start_link(children(@target), opts)
    opts = [strategy: :one_for_one, name: Firmware.GPIO1602]
    Supervisor.start_link(childred(:gpio1602), opts)
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
