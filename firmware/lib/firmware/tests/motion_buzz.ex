defmodule Firmware.Tests.MotionBuzz do
  alias Nerves.Grove.Sensor.MotionSensor
  alias Nerves.Grove.Buzzer

  @type input(buzz_pid, sensor_pid, pin_buzz, pin_sensor) :: [
          {buzz_pid, sensor_pid, pin_buzz, pin_sensor}
        ]
  def start_alarm(pin_buzz, pin_sensor) do
    {:ok, buzz_pid} = Buzzer.start_link(pin_buzz)
    {:ok, sensor_pid} = MotionSensor.start_link(pin_sensor)
    input = {buzz_pid, sensor_pid, pin_buzz, pin_sensor}

    self =
      Task.start(fn ->
        loop(input)
      end)

    self
  end

  def check_sensor(input) do
    if MotionSensor.read(input.sensor_pid) == false do
      Buzzer.beep(input.buzz_pid, 0.25)
    end
  end

  @spec send_stop(pid()) :: pid()
  def send_stop(pid) do
    send(pid, :stop)
  end

  @spec stop(pid()) :: pid()
  def stop(pid) do
    IO.puts("Shutting down alarm")
    send(pid, :stop)
    Process.exit(pid, :stop)
  end

  def loop(input) do
    IO.puts("Alarm activated")
    check_sensor(input)
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
