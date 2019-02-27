defmodule Firmware.Cuadruped.Inclination do
  use GenServer
  require Logger
  import Firmware.Cuadruped.Positions


  @fr %{b: :frb, h: :frh, k: :frk}

  @br %{b: :brb, h: :brh, k: :brk}

  @bl %{b: :blb, h: :blh, k: :blk}

  @fl %{b: :flb, h: :flh, k: :flk}


  def start_link(device) do
    GenServer.start_link(__MODULE__, device, name: __MODULE__)
  end

  def init(device) do
    state = %{}
    InputEvent.start_link(device)
    {:ok, state}
  end

  def handle_info({:input_event, "/dev/input/event0", event}, state) do
    case event do
      # Button Y
      [{:ev_msc, :msc_scan, 589_825}, {:ev_key, :btn_a, 1}] ->
        move_hip(@fl, 70)
        move_hip(@fr, 70)

      [{:ev_msc, :msc_scan, 589_825}, {:ev_key, :btn_a, 0}] ->
        move_hip(@fl, 45)
        move_hip(@fr, 45)

      # Button B
      [{:ev_msc, :msc_scan, 589_826}, {:ev_key, :btn_b, 1}] ->
        move_hip(@br, 70)
        move_hip(@fr, 70)

      [{:ev_msc, :msc_scan, 589_826}, {:ev_key, :btn_b, 0}] ->
        move_hip(@br, 45)
        move_hip(@fr, 45)

      # Button A
      [{:ev_msc, :msc_scan, 589_827}, {:ev_key, :btn_c, 1}] ->
        move_hip(@bl, 70)
        move_hip(@br, 70)

      [{:ev_msc, :msc_scan, 589_827}, {:ev_key, :btn_c, 0}] ->
        move_hip(@bl, 45)
        move_hip(@br, 45)

      # Button X
      [{:ev_msc, :msc_scan, 589_828}, {:ev_key, :btn_x, 1}] ->
        move_hip(@fl, 70)
        move_hip(@bl, 70)

      [{:ev_msc, :msc_scan, 589_828}, {:ev_key, :btn_x, 0}] ->
        move_hip(@fl, 45)
        move_hip(@bl, 45)

      _ ->
        Logger.debug("Tilt fn not implemented")
    end
    {:noreply, state}
  end
end
