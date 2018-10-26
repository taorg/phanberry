defmodule Firmware.Cuadruped.Handle_joystick do
  require Logger
  import Firmware.Cuadruped.Movements

  def handle(data) do
    Logger.debug("
    ////////////////////////////////////////////////
    ////////////////////////////////////////////////
    #{inspect(data)}
    ////////////////////////////////////////////////
    ////////////////////////////////////////////////
    ")

    fun(data)
  end

  def fun(%EventBus.Model.Event{data: %{jstick_event: event}}) do
    Logger.debug("
    //////////////////////
    #{inspect(event)}
    //////////////////////
    ")
    Logger.debug("Moving to #{inspect(event)}")

    case event do
      "dir:up" ->
        move(:fw)

      "dir:right" ->
        move(:rt)

      "dir:down" ->
        move(:bw)

      "dir:left" ->
        move(:lft)

      _ ->
        nil
    end
  end

  def fun(%EventBus.Model.Event{data: %{jstick_obj: obj}}) do
    Logger.debug("
    ////////////////////
    #{inspect(obj)}
    ////////////////////
    ")
  end
end
