defmodule Firmware.Cuadruped.Movements do
  require Logger
  import Firmware.Cuadruped.Positions

  @fr %{b: :frb, h: :frh, k: :frk}

  @br %{b: :brb, h: :brh, k: :brk}

  @bl %{b: :blb, h: :blh, k: :blk}

  @fl %{b: :flb, h: :flh, k: :flk}

  @bs [:frb, :brb, :blb, :flb]
  @hs [:frh, :brh, :blh, :flh]
  @ks [:frk, :brk, :blk, :flk]

  @move_sleep 500
  ######################################
  ######################################
  # funs to step forward
  def step_left_fw() do
    lift_leg(@bl)

    move_leg(@bl, 45)
    Process.sleep(@move_sleep)
    drop_leg(@bl)
    Process.sleep(@move_sleep)

    lift_leg(@fl)

    move_leg(@fr, 125)

    move_leg(@br, 125)

    move_leg(@bl, 90)
    Process.sleep(@move_sleep)

    move_leg(@fl, 125)
    Process.sleep(@move_sleep)
    drop_leg(@fl)
  end

  def step_right_fw() do
    lift_leg(@br)

    move_leg(@br, 45)
    Process.sleep(@move_sleep)
    drop_leg(@br)
    Process.sleep(@move_sleep)

    lift_leg(@fr)

    move_leg(@fl, 125)

    move_leg(@bl, 125)

    move_leg(@br, 90)
    Process.sleep(@move_sleep)

    move_leg(@fr, 45)
    Process.sleep(@move_sleep)
    drop_leg(@fr)
  end

  # //////////////////////////////////////
  # funs to step backwards
  def step_left_bw() do
    lift_leg(@fl)

    move_leg(@fl, 45)
    Process.sleep(@move_sleep)
    drop_leg(@fl)
    Process.sleep(@move_sleep)

    lift_leg(@bl)

    move_leg(@br, 125)

    move_leg(@fr, 125)

    move_leg(@fl, 90)
    Process.sleep(@move_sleep)

    move_leg(@bl, 125)
    Process.sleep(@move_sleep)
    drop_leg(@bl)
  end

  def step_right_bw() do
    lift_leg(@fr)

    move_leg(@fr, 45)
    Process.sleep(@move_sleep)
    drop_leg(@fr)
    Process.sleep(@move_sleep)

    lift_leg(@br)

    move_leg(@bl, 125)

    move_leg(@fl, 125)

    move_leg(@fr, 90)
    Process.sleep(@move_sleep)

    move_leg(@br, 125)
    Process.sleep(@move_sleep)
    drop_leg(@br)
  end

  # //////////////////////////////////////
  # funs to step to the left
  def step_back_lft() do
    lift_leg(@br)

    move_leg(@br, 45)
    Process.sleep(@move_sleep)
    drop_leg(@br)
    Process.sleep(@move_sleep)

    lift_leg(@bl)

    move_leg(@fl, 125)

    move_leg(@fr, 125)

    move_leg(@br, 90)
    Process.sleep(@move_sleep)

    move_leg(@bl, 125)
    Process.sleep(@move_sleep)
    drop_leg(@bl)
  end

  def step_front_lft() do
    lift_leg(@fr)

    move_leg(@fr, 45)
    Process.sleep(@move_sleep)
    drop_leg(@fr)
    Process.sleep(@move_sleep)

    lift_leg(@fl)

    move_leg(@bl, 125)

    move_leg(@br, 125)

    move_leg(@fr, 90)
    Process.sleep(@move_sleep)

    move_leg(@fl, 125)
    Process.sleep(@move_sleep)
    drop_leg(@fl)
  end

  # //////////////////////////////////////
  # funs to step to the right
  def step_back_rt() do
    lift_leg(@bl)

    move_leg(@bl, 45)
    Process.sleep(@move_sleep)
    drop_leg(@bl)
    Process.sleep(@move_sleep)

    lift_leg(@br)

    move_leg(@fl, 125)

    move_leg(@fr, 125)

    move_leg(@bl, 90)
    Process.sleep(@move_sleep)

    move_leg(@br, 125)
    Process.sleep(@move_sleep)
    drop_leg(@br)
  end

  def step_front_rt() do
    lift_leg(@fl)

    move_leg(@fl, 45)
    Process.sleep(@move_sleep)
    drop_leg(@fl)
    Process.sleep(@move_sleep)

    lift_leg(@fr)

    move_leg(@bl, 125)

    move_leg(@br, 125)

    move_leg(@fl, 90)
    Process.sleep(@move_sleep)

    move_leg(@fr, 125)
    Process.sleep(@move_sleep)
    drop_leg(@fr)
  end

  ######################################
  ######################################

  def move(dir) do
    case dir do
      :fw ->
        step_left_fw()
        step_right_fw()

      :bw ->
        step_left_bw()
        step_right_bw()

      :lft ->
        step_back_lft()
        step_front_lft()

      :rt ->
        step_back_rt()
        step_front_rt()
    end
  end

  def run_frl() do
    lift_leg(@fr)

    lift_leg(@bl)

    move_leg(@br, 45)

    move_leg(@fl, 45)

    move_leg(@fr, 45)

    move_leg(@bl, 45)
    Process.sleep(@move_sleep)

    drop_leg(@fr)

    drop_leg(@bl)
  end

  def run_fll() do
    lift_leg(@fl)

    lift_leg(@br)

    move_leg(@bl, 45)

    move_leg(@fr, 45)

    move_leg(@fl, 45)

    move_leg(@br, 45)
    Process.sleep(@move_sleep)

    drop_leg(@fl)

    drop_leg(@br)
  end

  def run() do
    run_frl()
    run_fll()
  end

  ######################################
  ######################################
  # Funs to turn clockwise
  def turn_cl_frl() do
    lift_leg(@fr)

    lift_leg(@bl)
    Process.sleep(@move_sleep)

    move_leg(@fl, 45)

    move_leg(@br, 45)

    move_leg(@fr, 125)

    move_leg(@bl, 125)
    Process.sleep(@move_sleep)

    drop_leg(@fr)

    drop_leg(@bl)
    Process.sleep(@move_sleep)
  end

  def turn_cl_fll() do
    lift_leg(@fl)

    lift_leg(@br)
    Process.sleep(@move_sleep)

    move_leg(@fr, 45)

    move_leg(@bl, 45)

    move_leg(@fl, 125)

    move_leg(@br, 125)
    Process.sleep(@move_sleep)

    drop_leg(@fl)

    drop_leg(@br)
    Process.sleep(@move_sleep)
  end

  # /////////////////////////////////////
  # Funs to turn anticlockwise
  def turn_anticl_frl() do
    lift_leg(@fr)

    lift_leg(@bl)
    Process.sleep(@move_sleep)

    move_leg(@fl, 125)

    move_leg(@br, 125)

    move_leg(@fr, 45)

    move_leg(@bl, 45)
    Process.sleep(@move_sleep)

    drop_leg(@fr)

    drop_leg(@bl)
    Process.sleep(@move_sleep)
  end

  def turn_anticl_fll() do
    lift_leg(@fl)

    lift_leg(@br)
    Process.sleep(@move_sleep)

    move_leg(@fr, 125)

    move_leg(@bl, 125)

    move_leg(@fl, 45)

    move_leg(@br, 45)
    Process.sleep(@move_sleep)

    drop_leg(@fl)

    drop_leg(@br)
    Process.sleep(@move_sleep)
  end

  ######################################
  ######################################

  def turn(dir) do
    case dir do
      :cl ->
        turn_cl_frl()
        turn_cl_fll()

      :anti ->
        turn_anticl_frl()
        turn_anticl_fll()
    end
  end

  def say_hi() do
    lift_leg(@fr)

    move_leg(@fr, 45)
    Process.sleep(@move_sleep + 200)

    for n <- 0..2 do
      move_knee(@fr, 0)
      Process.sleep(@move_sleep)
      move_knee(@fr, 90)
      Process.sleep(@move_sleep)
    end

    move_leg(@fr, 90)
    Process.sleep(@move_sleep)
    initial()
  end
end
