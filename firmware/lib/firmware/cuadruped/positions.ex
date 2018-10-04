defmodule Firmware.Cuadruped.Positions do
  require Logger
  alias Nerves.Grove.Servo

  @moduledoc """
  This module will set some leg positions so they can be combined later in the Firmware.Cuadruped.Movements

  leg = %{b: 18, h: 23, k: 24}
alias Firmware.Cuadruped.Positions
alias Nerves.Grove.Servo

    Servo.rotate(leg.b, 90)
    Servo.rotate(leg.h, 90)
    Servo.rotate(leg.k, 90)
  """
  @fr %{b: 23, h: 18, k: 24}

  @br %{b: 25, h: 12, k: 16}

  @bl %{b: 17, h: 27, k: 22}

  @fl %{b: 13, h: 19, k: 26}

  @doc """
  The pins for the servos are set here, e.g.: frb = front right body
  """

  def initial(leg) do
    Logger.debug("Into the initial fn, #{inspect(leg)}")
    Servo.rotate(leg.b, 90)
    Servo.rotate(leg.h, 90)
    Servo.rotate(leg.k, 90)
    Logger.debug("Into the initial fn, #{inspect(leg)}, body pin = #{inspect(leg.b)} ")
  end

  def invoke() do
    initial(@fr)
  end
end
