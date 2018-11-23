defmodule Firmware.Cuadruped.Handle_joystick.Srvr do
  use GenServer
  require Logger

  import Firmware.Cuadruped.Movements

  def init(opts) do
    state = opts
    {:ok, state}
  end

  def handle_cast({:event, event}, _state) do
    state = %{is_loop_on: :on, dir: event}
    check_loop(state.is_loop_on)
    Logger.debug("Loop initiated")
    {:noreply, state}
  end

  def handle_cast({:end, "end"}, state) do
    state = %{state | is_loop_on: :off}
    Logger.debug("Loop stoped")
    {:noreply, state}
  end

  def handle_info(:left_loop, state) do
    is_loop_on = state.is_loop_on

    if is_loop_on === :on do
      left_loop(state.dir)
      Process.send(self(), :right_loop, [:nosuspend])
    end

    {:noreply, state}
  end

  def handle_info(:right_loop, state) do
    is_loop_on = state.is_loop_on

    if is_loop_on === :on do
      right_loop(state.dir)
      Process.send(self(), :left_loop, [:nosuspend])
    end

    {:noreply, state}
  end

  defp check_loop(is_loop_on) do
    if is_loop_on === :on do
      Process.send(self(), :left_loop, [:nosuspend])
    end
  end

  def left_loop(dir) do
    # Logger.debug("Moving to #{inspect(dir)}")

    case dir do
      "dir:up" ->
        step_left_fw()

      "dir:right" ->
        step_back_rt()

      "dir:down" ->
        step_left_bw()

      "dir:left" ->
        step_back_lft()

      _ ->
        nil
    end
  end

  def right_loop(dir) do
    # Logger.debug("Moving to #{inspect(dir)}")

    case dir do
      "dir:up" ->
        step_right_fw()

      "dir:right" ->
        step_front_rt()

      "dir:down" ->
        step_right_bw()

      "dir:left" ->
        step_front_lft()

      _ ->
        nil
    end
  end
end
