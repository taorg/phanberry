defmodule Firmware.Cuadruped.Positions do
  require Logger
  alias Nerves.Grove.PCA9685.{Servo, Tetrapod}

  @moduledoc """
    This module will set some leg positions so they can be combined later in the Firmware.Cuadruped.Movements

    alias Firmware.Cuadruped.Positions


    @fr %{b: :frb, h: :frh, k: :frk}

    @br %{b: :brb, h: :brh, k: :brk}

    @bl %{b: :blb, h: :blh, k: :blk}

    @fl %{b: :flb, h: :flh, k: :flk}
  """
  @bs [:frb, :brb, :blb, :flb]
  @hs [:frh, :brh, :blh, :flh]
  @ks [:frk, :brk, :blk, :flk]

  @doc """
  The pins for the servos are set here, e.g.: frb = front right body
  """

  def initial() do
    for n <- @bs do
      Servo.position(Tetrapod.limb_id(n), 90)
    end

    for n <- @hs do
      Servo.position(Tetrapod.limb_id(n), 45)
    end

    for n <- @ks do
      Servo.position(Tetrapod.limb_id(n), 90)
    end
  end

  def lift_leg(leg) do
    Servo.position(Tetrapod.limb_id(leg.h), 90)
  end

  def drop_leg(leg) do
    Servo.position(Tetrapod.limb_id(leg.h), 45)
  end

  def move_knee(leg, angle) do
    Servo.position(Tetrapod.limb_id(leg.k), angle)
  end

  def move_hip(leg, angle) do
    Servo.position(Tetrapod.limb_id(leg.h), angle)
  end

  def move_leg(leg, angle) do
    Servo.position(Tetrapod.limb_id(leg.b), angle)
  end

  def sit(n \\ 45) do
    n = n + 5

    for c <- @hs do
      Servo.position(Tetrapod.limb_id(c), n)
    end

    Process.sleep(250)

    if n < 90 do
      sit(n)
    else
      end_sit()
    end
  end

  def end_sit() do
    for c <- @ks do
      Servo.position(Tetrapod.limb_id(c), 90)
    end
  end

  def lay(n \\ 45) do
    n = n - 5

    for c <- @hs do
      Servo.position(Tetrapod.limb_id(c), n)
    end

    Process.sleep(250)

    if n < 0 do
      sit(n)
    else
      end_lay()
    end
  end

  def end_lay() do
    for c <- @ks do
      Servo.position(Tetrapod.limb_id(c), 0)
    end
  end
end
