defmodule Firmware.Cuadruped.Dance do
  import Firmware.Cuadruped.Positions

  @moduledoc """
  The purpose of the module is solely to make the robot perform a little dance


  @fr %{b: :frb, h: :frh, k: :frk}

  @br %{b: :brb, h: :brh, k: :brk}

  @bl %{b: :blb, h: :blh, k: :blk}

  @fl %{b: :flb, h: :flh, k: :flk}

  @bs [:frb, :brb, :blb, :flb]
  @hs [:frh, :brh, :blh, :flh]
  @ks [:frk, :brk, :blk, :flk]
  """
  def some() do
    initial()
  end
end
