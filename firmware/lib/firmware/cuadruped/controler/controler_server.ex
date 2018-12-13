defmodule Firmware.Cuadruped.Controler.Srvr do
  use GenServer
  require Logger
  import Firmware.Cuadruped.{Movements, Positions}

  @moduledoc """
  To test this module:
  alias Nerves.Grove.PCA9685.{Tetrapod,Servo}
  Tetrapod.start_shield()
  Firmware.Cuadruped.Controler.Superisor.start_link({})
  RingLogger.attach
  """

  def init(_opts) do
    state = %{is_moving: :no, step_to_do: :right}
    InputEvent.enumerate()
    Process.sleep(5000)
    [device] = InputEvent.Enumerate.all_devices()
    Logger.debug("Device = #{inspect(device)}")
    InputEvent.start_link(device)
    Process.sleep(500)
    {:ok, state}
  end

  def handle_info({:input_event, "/dev/input/event0", event}, state) do
    Logger.debug("I got this event: #{inspect(event)}")
    process_event(event)
    {:noreply, state}
  end

  def process_event(event) do
    case event do
      # Cross up
      [{:ev_abs, :abs_y, 0}] ->
        initial()

      # Cross down
      [{:ev_abs, :abs_y, 255}] ->
        sit()

      # Top big left
      [{:ev_msc, :msc_scan, 589_831}, {:ev_key, :btn_tl, 1}] ->
        say_hi()

      # Left jstk up
      [{:ev_abs, :abs_hat0y, -1}] ->
        Process.send(self(), {:start_moving, "fw"}, [:nosuspend])

      [{:ev_abs, :abs_hat0y, 0}] ->
        Process.send(self(), :stop_moving, [:nosuspend])

      _ ->
        Logger.debug("Fn not implemented")
    end
  end

  def handle_info({:start_moving, dir}, state) do
    server_move(dir)
    state = %{state | is_moving: :yes}
    {:noreply, state}
  end

  def server_move(dir) do
    Process.sleep(1)
    Process.send(self(), {:move, dir}, [:nosuspend])
  end

  def handle_info(:stop_moving, state) do
    Logger.debug("Stop moving")
    state = %{state | is_moving: :no}
    {:noreply, state}
  end

  def handle_info({:move, dir}, state) do
    Logger.debug("Got here with this state: #{inspect(state)}")

    if state.is_moving == :yes do
      step_to_do = state.step_to_do

      case step_to_do do
        :right ->
          right_step(dir)

        :left ->
          left_step(dir)
      end

      Logger.debug("Moving")
      Process.send(self(), {:move, dir}, [:nosuspend])
    end

    {:noreply, state}
  end

  def left_step(dir) do
    case dir do
      "fwd" ->
        step_left_fw()

      "right" ->
        step_back_rt()

      "back" ->
        step_left_bw()

      "left" ->
        step_back_lft()

      _ ->
        nil
    end
  end

  def right_step(dir) do
    case dir do
      "fwd" ->
        step_right_fw()

      "right" ->
        step_front_rt()

      "back" ->
        step_right_bw()

      "left" ->
        step_front_lft()

      _ ->
        nil
    end
  end
end
