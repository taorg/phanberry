defmodule Firmware.Tests.MotionBuzz do
  alias Nerves.Grove.Sensor.MotionSensor
  alias Nerves.Grove.Buzzer

  def start_alarm(pin_buzz, pin_sensor, n) when n<10 do
    {:ok, buzz_pid} = Buzzer.star_link(pin_buzz)
    {:ok, sensor_pid} = MotionSensor.star_link(pin_sensor)

    if MotionSensor.read(sensor_pid) == true do
      Buzzer.beep(buzz_pid, 0.5)
    end
    Process.sleep(1000)

    start_alarm(pin_buzz, pin_sensor, n + 1)

  end

end
