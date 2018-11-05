defmodule Firmware.Cuadruped.Handle_joystick.Srvr do
  use GenServer
  require Logger

  import Firmware.Cuadruped.Movements

  def init(:ok) do
    state = :ok
    {:ok, state}
  end

  def handle_cast({:event, event}, state) do
    state = %{is_on: :on, dir: event}
    check_loop(state.is_on)
    Logger.debug("Loop initiated")
    {:noreply, state}
  end

  def handle_cast({:end, "end"}, state) do
    state = %{state | is_on: :off}
    Logger.debug("Loop stoped")
    {:noreply, state}
  end

  def handle_info(:loop, state) do
    loop(state.dir)
    check_loop(state.is_on)
  end

  defp check_loop(is_on) do
    if is_on === :on do
      Process.send(self(), :loop, [:nosuspend])
    end
  end

  def loop(dir) do
    Logger.debug("Moving to #{inspect(dir)}")

    case dir do
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
end
