defmodule Firmware.Cuadruped.Positions do
  require Logger
  alias Nerves.Grove.PCA9685.Device

  @moduledoc """
  This module will set some leg positions so they can be combined later in the Firmware.Cuadruped.Movements

  alias Firmware.Cuadruped.Positions

  """
  @fr %{b: 0, h: 1, k: 2}

  @br %{b: 3, h: 4, k: 5}

  @bl %{b: 6, h: 7, k: 8}

  @fl %{b: 9, h: 10, k: 11}

  @bs [0, 3, 6, 9]
  @hs [1, 4, 7, 10]
  @ks [2, 5, 8, 11]

  @sleep 5

  @doc """
  The pins for the servos are set here, e.g.: frb = front right body
  """

  def initial(handle) do
    for n <- @bs do
      Device.set_servo(handle, n, 90)
      Process.sleep(@sleep)
    end

    for n <- @hs do
      Device.set_servo(handle, n, 45)
      Process.sleep(@sleep)
    end

    for n <- @ks do
      Device.set_servo(handle, n, 90)
      Process.sleep(@sleep)
    end
  end

  def lift_leg(handle, leg) do
    Device.set_servo(handle, leg.h, 90)
  end

  def drop_leg(handle, leg) do
    Device.set_servo(handle, leg.h, 45)
  end

  def move_knee(handle, leg, angle) do
    Device.set_servo(handle, leg.k, angle)
  end

  def move_leg(handle, leg, dir) do
    case dir do
      :fw ->
        Device.set_servo(handle, leg.b, 180)

      :bw ->
        Device.set_servo(handle, leg.b, 0)
    end
  end

  def y_body(handle, dir, angle) do
    case dir do
      :up ->
        angle = angle + 10

      :down ->
        angle = angle - 10
    end

    for n <- @hs do
      Device.set_servo(handle, n, angle)
      Process.sleep(@sleep)
    end
  end
end
