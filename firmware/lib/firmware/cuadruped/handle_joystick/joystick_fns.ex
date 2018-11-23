defmodule Firmware.Cuadruped.Handle_joystick.Fns do
  require Logger

  @moduledoc """
  To test this module:
  RingLogger.attach()
  alias Nerves.Grove.PCA9685.{Tetrapod,Servo}
  Tetrapod.start_shield()
  Firmware.Cuadruped.Handle_joystick.Supervisor.start_link(%{})

  """

  def start_link(opts) do
    GenServer.start_link(Firmware.Cuadruped.Handle_joystick.Srvr, opts, name: via_tuple())
  end

  defp via_tuple(),
    do: {:via, Registry, {:joystick_registry, :joystick_server}}

  def handle(data) do
    joystick_info(data)
  end

  def joystick_info(%EventBus.Model.Event{data: %{jstick_event: "end"}}) do
    Logger.debug("
    //////////////////////
    Event = #{inspect("end")}
    //////////////////////
    ")

    GenServer.cast(via_tuple(), {:end, "end"})
  end

  def joystick_info(%EventBus.Model.Event{data: %{jstick_event: event}})
      when event === "dir:left" or event === "dir:up" or event === "dir:right" or
             event === "dir:down" do
    Logger.debug("
    //////////////////////
    Event = #{inspect(event)}
    //////////////////////
    ")

    GenServer.cast(via_tuple(), {:event, event})
  end

  def joystick_info(%EventBus.Model.Event{data: %{jstick_event: _event}}) do
  end

  def joystick_info(%EventBus.Model.Event{data: %{jstick_obj: _obj}}) do
  end
end
