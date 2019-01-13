defmodule Firmware.Cuadruped.Grabber do
  use GenServer
  require Logger
  alias Nerves.Grove.PCA9685.{Servo, Tetrapod}

  def start_link(device) do
    GenServer.start_link(__MODULE__, device, name: __MODULE__)
  end

  def init(device) do
    state = %{grabberx: 90, grabbery: 90, is_moving: :no, how_closed: 0, is_closing: :no}
    InputEvent.start_link(device)
    {:ok, state}
  end

  def handle_info({:input_event, "/dev/input/event0", event}, state) do
    state =
      case event do
        [{:ev_msc, :msc_scan, 589_830}, {:ev_key, :btn_z, 1}] ->
          Process.send(self(), :close, [:nosuspend])
          state = %{state | is_closing: :yes}
          state

        [{:ev_msc, :msc_scan, 589_830}, {:ev_key, :btn_z, 0}] ->
          Process.send(self(), :stop_closing, [:nosuspend])
          state

        [{:ev_msc, :msc_scan, 589_832}, {:ev_key, :btn_tr, 1}] ->
          Process.send(self(), :open, [:nosuspend])
          state = %{state | is_closing: :yes}
          state

        [{:ev_msc, :msc_scan, 589_830}, {:ev_key, :btn_tr, 0}] ->
          Process.send(self(), :stop_closing, [:nosuspend])
          state

        # Button Y
        [{:ev_msc, :msc_scan, 589_825}, {:ev_key, :btn_a, 1}] ->
          Process.send(self(), {:dir, "up"}, [:nosuspend])
          state = %{state | is_moving: :yes}
          state

        # Button B
        [{:ev_msc, :msc_scan, 589_826}, {:ev_key, :btn_b, 1}] ->
          Process.send(self(), {:dir, "right"}, [:nosuspend])
          state = %{state | is_moving: :yes}
          state

        # Button A
        [{:ev_msc, :msc_scan, 589_827}, {:ev_key, :btn_c, 1}] ->
          Process.send(self(), {:dir, "down"}, [:nosuspend])
          state = %{state | is_moving: :yes}
          state

        # Button X
        [{:ev_msc, :msc_scan, 589_828}, {:ev_key, :btn_x, 1}] ->
          Process.send(self(), {:dir, "left"}, [:nosuspend])
          state = %{state | is_moving: :yes}
          state

        [{:ev_msc, :msc_scan, _}, {:ev_key, _, 0}] ->
          Process.send(self(), :stop_moving, [:nosuspend])
          state

        _ ->
          Logger.debug("Grabber fn not implemented")
          state
      end

    {:noreply, state}
  end

  def handle_info(:stop_moving, state) do
    Logger.debug("Stop moving grabber")
    state = %{state | is_moving: :no}
    {:noreply, state}
  end

  def handle_info(:stop_closing, state) do
    Logger.debug("Stop closing grabber")
    state = %{state | is_closing: :no}
    {:noreply, state}
  end

  def handle_info(:open, state) do
    if state.how_closed > 180 and state.is_closing == :yes do
      opening = state.how_closed + 5
      Servo.position(Tetrapod.limb_id(:pinza), opening)
      state = %{state | how_closed: opening}
      Process.sleep(500)
      Process.send(self(), :open, [:nosuspend])
      state
    end
  end

  def handle_info(:close, state) do
    if state.how_closed < 0 and state.is_closing == :yes do
      opening = state.how_closed - 5
      Servo.position(Tetrapod.limb_id(:pinza), opening)
      state = %{state | how_closed: opening}
      Process.sleep(500)
      Process.send(self(), :close, [:nosuspend])
      state
    end
  end

  def handle_info({:dir, dir}, state) do
    Process.sleep(500)

    state =
      if state.is_moving == :yes do
        case dir do
          "up" ->
            pos = state.grabbery + 10
            Servo.position(Tetrapod.limb_id(:ypinza), pos)
            state = %{state | grabbery: pos}
            Process.sleep(500)
            Process.send(self(), {:dir, dir}, [:nosuspend])
            state

          "right" ->
            pos = state.grabberx + 10
            Servo.position(Tetrapod.limb_id(:xpinza), pos)
            state = %{state | grabberx: pos}
            Process.sleep(500)
            Process.send(self(), {:dir, dir}, [:nosuspend])
            state

          "down" ->
            pos = state.grabbery - 10
            Servo.position(Tetrapod.limb_id(:ypinza), pos)
            state = %{state | grabbery: pos}
            Process.sleep(500)
            Process.send(self(), {:dir, dir}, [:nosuspend])
            state

          "left" ->
            pos = state.grabberx - 10
            Servo.position(Tetrapod.limb_id(:xpinza), pos)
            state = %{state | grabberx: pos}
            Process.sleep(500)
            Process.send(self(), {:dir, dir}, [:nosuspend])
            state
        end
      else
        state
      end

    {:noreply, state}
  end
end
