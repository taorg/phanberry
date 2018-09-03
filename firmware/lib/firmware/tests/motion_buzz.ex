defmodule Firmware.Tests.MotionBuzz do
  alias Nerves.Grove.Sensor.MotionSensor
  alias Nerves.Grove.Buzzer

  def check_sensor(pin_buzz, pin_sensor) do
    {:ok, buzz_pid} = Buzzer.start_link(pin_buzz)
    {:ok, sensor_pid} = MotionSensor.start_link(pin_sensor)

    if MotionSensor.read(sensor_pid) == false do
      Buzzer.beep(buzz_pid, 0.25)
    end

    Process.sleep(250)
    loop(pin_buzz, pin_sensor)
    # check_sensor(pin_buzz, pin_sensor, n-1)
  end

  def send_stop(pid) do
    send(pid, :stop)
  end

  def start_alarm(pin_buzz, pin_sensor) do
    {:ok, buzz_pid} = Buzzer.start_link(pin_buzz)
    {:ok, sensor_pid} = MotionSensor.start_link(pin_sensor)

    Task.start(fn ->
      loop(pin_buzz, pin_sensor)
    end)
  end

  def send_stop(pid) do
    IO.puts("Shutting down alarm")
    send(pid, :stop)
    Process.exit(pid, :stop)
  end

  def loop(pin_buzz, pin_sensor) do
    IO.puts("Alarm activated")
    check_sensor(pin_buzz, pin_sensor)
    # Process.sleep(500)

    receive do
      :stop ->
        IO.puts("Stopping...")
        # Process.sleep(100)
        exit(:shutdown)
    end

    Process.sleep(300)
    # loop(pin_buzz, pin_sensor)
  end
end
