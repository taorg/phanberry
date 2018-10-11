defmodule Firmware.Cuadruped.Movements do
  require Logger
  import Firmware.Cuadruped.Positions

  @fr %{b: 0, h: 1, k: 2}

  @br %{b: 3, h: 4, k: 5}

  @bl %{b: 6, h: 7, k: 8}

  @fl %{b: 9, h: 10, k: 11}

  @bs [0, 3, 6, 9]
  @hs [1, 4, 7, 10]
  @ks [2, 5, 8, 11]

  @sleep 5
  @move_sleep 500

  def leg_step(handle, leg, dir) do
    lift_leg(handle, leg)
    Process.sleep(@move_sleep)

    case dir do
      :bw ->
        case leg do
          @fr ->
            move_leg(handle, leg, :fw)

          @br ->
            move_leg(handle, leg, :fw)

          @fl ->
            move_leg(handle, leg, :bw)

          @bl ->
            move_leg(handle, leg, :bw)
        end

      :fw ->
        case leg do
          @fr ->
            move_leg(handle, leg, :bw)

          @br ->
            move_leg(handle, leg, :bw)

          @fl ->
            move_leg(handle, leg, :fw)

          @bl ->
            move_leg(handle, leg, :fw)
        end
    end

    Process.sleep(@move_sleep)
    drop_leg(handle, leg)
  end

  def move(handle, dir) do
    for n <- [@fr, @br, @fl, @bl] do
      leg_step(handle, n, dir)
      Process.sleep(@move_sleep)
    end

    initial(handle)
  end

  def say_hi(handle) do
    lift_leg(handle, @fr)
    Process.sleep(@sleep)
    move_leg(handle, @fr, :bw)
    Process.sleep(@move_sleep + 200)

    for n <- 0..2 do
      move_knee(handle, @fr, 0)
      Process.sleep(@move_sleep)
      move_knee(handle, @fr, 90)
      Process.sleep(@move_sleep)
    end

    initial(handle)
  end

  def turn(handle, dir) do
    case dir do
      :lft ->
        for n <- [@fr, @br, @bl, @fl] do
          lift_leg(handle, n)
          Process.sleep(@move_sleep)
          move_leg(handle, n, :fw)
          Process.sleep(@move_sleep)
          drop_leg(handle, n)
          Process.sleep(@sleep)
        end

        initial(handle)

      :rt ->
        for n <- [@fr, @br, @bl, @fl] do
          lift_leg(handle, n)
          Process.sleep(@move_sleep)
          move_leg(handle, n, :bw)
          Process.sleep(@move_sleep)
          drop_leg(handle, n)
          Process.sleep(@sleep)
        end

        initial(handle)
    end
  end
end
