defmodule Firmware.Cuadruped.Handle_joystick.Fns do
  require Logger

  @moduledoc """
  To test this module:

  alias Firmware.Cuadruped.Handle_joystick.Fns
  {:ok, pid} = Fns.start_link()
  Fns.handle("dir:up", pid) #This should start the loop
  Fns.handle("end", pid) #This should stop it

  """

  def start_link() do
    GenServer.start_link(Firmware.Cuadruped.Handle_joystick.Srvr, :ok, name: __MODULE__)
  end

  def handle(data, pid) do
    Logger.debug("
    ////////////////////////////////////////////////
    ////////////////////////////////////////////////
    #{inspect(data)}
    ////////////////////////////////////////////////
    ////////////////////////////////////////////////
    ")

    joystick_info(data, pid)
  end


  def joystick_info(%EventBus.Model.Event{data: %{jstick_event: "end"}}, pid) do
    Logger.debug("
    //////////////////////
    Event = #{inspect("end")}
    //////////////////////
    ")

    GenServer.cast(pid, {:end, "end"})
  end

  def joystick_info(%EventBus.Model.Event{data: %{jstick_event: event}}, pid) when event === "dir:up" or "dir:left" or "dir:right" or "dir:down" do
    Logger.debug("
    //////////////////////
    Event = #{inspect(event)}
    //////////////////////
    ")

    GenServer.cast(pid, {:event, event})
  end

  def joystick_info(%EventBus.Model.Event{data: %{jstick_event: event}}, pid) do
    Logger.debug("
    //////////////////////
    Event = #{inspect(event)}
    //////////////////////
    ")
  end

  def joystick_info(%EventBus.Model.Event{data: %{jstick_obj: obj}}, pid) do
    Logger.debug("
    ////////////////////
    Object = #{inspect(obj)}
    ////////////////////
    ")
  end

end
