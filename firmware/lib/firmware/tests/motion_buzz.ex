defmodule Firmware.Tests.MotionBuzz do
  require Logger
  alias Nerves.Grove.Sensor.MotionSensor
  alias Nerves.Grove.Buzzer


  @type input(buzz_pid, sensor_pid, pin_buzz, pin_sensor) ::
          [{buzz_pid, sensor_pid, pin_buzz, pin_sensor}]

  def start_alarm(pin_buzz, pin_sensor) do
    {:ok, buzz_pid} = Buzzer.start_link(pin_buzz)
    {:ok, sensor_pid} = MotionSensor.start_link(pin_sensor)
    input = {buzz_pid, sensor_pid, pin_buzz, pin_sensor}

    task_pid =
      Task.start(fn ->
        loop(input)
      end)

    task_pid
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
    Logger.debug("Shutting down alarm")
    send(pid, :stop)
    Process.exit(pid, :stop)
  end

  def loop(input) do
    check_sensor(input)
    Logger.debug("Alarm activated")

    receive do
      :stop ->
        Logger.debug("Stopping...")
        Process.sleep(100)
        exit(:shutdown)
    end

    Process.sleep(300)
  end
end
