defmodule Firmware.Tests.ExLcd do
  alias ExLCD

  def start_demo do
    wait_a_sec()
    clear()
    hello_joe()
    wait_a_sec()
    character_stream()
    start_demo()
  end

  def clear do
    ExLCD.clear()
    ExLCD.enable(:display)
  end

  def wait_a_sec do
    Process.sleep(1000)
  end

  def hello_joe do
    ExLCD.write("Hello, Joe")

    for _ <- 1..10 do
      for _ <- 1..6 do
        ExLCD.scroll_right()
        Process.sleep(250)
      end

      for _ <- 1..6 do
        ExLCD.scroll_left()
        Process.sleep(250)
      end
    end

    for _ <- 1..10 do
      ExLCD.scroll_left()
      Process.sleep(250)
    end
  end

  def character_stream do
    ExLCD.home()

    for char <- 0..255 do
      for row <- 0..1 do
        ExLCD.move_to(row, 0)
        ExLCD.write("0x" <> Integer.to_string(char, 16) <> ": ")

        for _ <- 0..9 do
          ExLCD.write([char])
        end

        Process.sleep(100)
      end
    end
  end
end
