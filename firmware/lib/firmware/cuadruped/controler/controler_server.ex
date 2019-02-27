defmodule Firmware.Cuadruped.Controler.Srvr do
  use GenServer
  require Logger
  import Firmware.Cuadruped.{Movements, Positions}

  @moduledoc """
  To test this module:
  Nerves.Grove.PCA9685.Tetrapod.start_shield()
  Firmware.Cuadruped.Controler.Superisor.start_link({})
  RingLogger.attach
  """

  def init(_opts) do
    state = %{is_moving: :no, step_to_do: :right}
    InputEvent.enumerate()
    Process.sleep(5000)

    if InputEvent.Enumerate.all_devices() == [] do
      Process.send(self(), :emergency, [:nosuspend])
    else
      [device] = InputEvent.Enumerate.all_devices()
      InputEvent.start_link(device)
      Firmware.Cuadruped.Inclination.start_link(device)
      Nerves.Grove.PCA9685.Tetrapod.start_shield()
      initial()
    end

    Process.sleep(500)
    {:ok, state}
  end

  def handle_info(:emergency, state) do
    Process.sleep(3000)
    Process.exit({:via, Registry, {:controler_registry, :controler_server}}, :kill)
    {:noreply, state}
  end

  def handle_info({:input_event, "/dev/input/event0", event}, state) do
    Logger.debug("I got this event: #{inspect(event)}")
    process_event(event, state)
    {:noreply, state}
  end

  def process_event(event, state) do
    case event do
      # Cross up
      [{:ev_abs, :abs_y, 0}] ->
        initial()

      # Cross down
      [{:ev_abs, :abs_y, 255}] ->
        sit()

      # Cross right
      [{:ev_abs, :abs_x, 255}] ->
        Process.send(self(), :im_yes, [:nosuspend])
        Process.send(self(), {:start_turn, :cl}, [:nosuspend])

      # Cross left
      [{:ev_abs, :abs_x, 0}] ->
        Process.send(self(), :im_yes, [:nosuspend])
        Process.send(self(), {:start_turn, :anti}, [:nosuspend])

      # Top big left
      [{:ev_msc, :msc_scan, 589_831}, {:ev_key, :btn_tl, 1}] ->
        say_hi()

      # Left jstk up
      [{:ev_abs, :abs_hat0y, -1}] ->
        Process.send(self(), :stop_moving, [:nosuspend])
        Process.sleep(1)
        Process.send(self(), :im_yes, [:nosuspend])
        Process.send(self(), {:start_moving, "fw", state}, [:nosuspend])

      # Left jstk down
      [{:ev_abs, :abs_hat0y, 1}] ->
        Process.send(self(), :stop_moving, [:nosuspend])
        Process.sleep(1)
        Process.send(self(), :im_yes, [:nosuspend])
        Process.send(self(), {:start_moving, "back", state}, [:nosuspend])

      # Left jstk right
      [{:ev_abs, :abs_hat0x, 1}] ->
        Process.send(self(), :stop_moving, [:nosuspend])
        Process.sleep(1)
        Process.send(self(), :im_yes, [:nosuspend])
        Process.send(self(), {:start_moving, "right", state}, [:nosuspend])

      # Left jstk left
      [{:ev_abs, :abs_hat0x, -1}] ->
        Process.send(self(), :stop_moving, [:nosuspend])
        Process.sleep(1)
        Process.send(self(), :im_yes, [:nosuspend])
        Process.send(self(), {:start_moving, "left", state}, [:nosuspend])

      # Top little
      [{:ev_msc, :msc_scan, 589_829}, {:ev_key, :btn_y, 1}] ->
        lay()

      # Start -> do a reboot
      [{:ev_msc, :msc_scan, 589_834}, {:ev_key, :btn_tr2, 1}] ->
        Nerves.Runtime.reboot()

      [{:ev_abs, _, 0}] ->
        Process.send(self(), :stop_moving, [:nosuspend])

      [{:ev_abs, _, 128}] ->
        Process.send(self(), :stop_moving, [:nosuspend])

      [{:ev_abs, _, 0}, {:ev_abs, _, 0}] ->
        Process.send(self(), :stop_moving, [:nosuspend])

      _ ->
        Logger.debug("Fn not implemented")
    end
  end

  def handle_info(:im_yes, state) do
    state = %{state | is_moving: :yes}
    {:noreply, state}
  end

  def handle_info({:start_turn, dir}, state) do
    Process.sleep(1)
    server_turn(dir, state)
    {:noreply, state}
  end

  def server_turn(dir, state) do
    if state.is_moving == :yes do
      turn(dir)

      Process.send(self(), {:start_turn, dir}, [:nosuspend])
    end
  end

  def handle_info({:start_moving, dir, real_state}, state) do
    Process.sleep(1)

    if state.is_moving == :yes do
      server_move(dir, real_state)
    end

    state = %{state | step_to_do: real_state.step_to_do}
    {:noreply, state}
  end

  def handle_info(:stop_moving, state) do
    Logger.debug("Stop moving")
    state = %{state | is_moving: :no}
    {:noreply, state}
  end

  def server_move(dir, state) do
    Logger.debug("Got here with this state: #{inspect(state)}")

    step_to_do = state.step_to_do

    new_state =
      case step_to_do do
        :right ->
          right_step(dir)
          new_state = %{state | step_to_do: :left}
          Logger.debug("Done right step")
          new_state

        :left ->
          left_step(dir)
          new_state = %{state | step_to_do: :right}
          Logger.debug("Done left step")
          new_state

        _ ->
          Logger.debug("Step to do not defined")
      end

    Process.send(self(), {:start_moving, dir, new_state}, [:nosuspend])
  end

  def left_step(dir) do
    case dir do
      "fw" ->
        step_fw()

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
      "fw" ->
        step_fw()

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
