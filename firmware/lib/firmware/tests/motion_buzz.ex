defmodule Firmware.Tests.MotionBuzz do
  require Logger
  alias Nerves.Grove.Sensor.MotionSensor
  alias Nerves.Grove.Buzzer


  @type input(buzz_pid, pin_buzz, pin_sensor) ::
          [{buzz_pid, pin_buzz, pin_sensor}]

  def start_alarm(pin_buzz, pin_sensor) do

    #input = {buzz_pid, pin_buzz, pin_sensor}

    task_pid =
      Task.start(fn ->
        loop(pin_buzz, pin_sensor)
      end)

    task_pid
  end

  def check_sensor(pin_buzz, pin_sensor) do
    Logger.debug("Sensor status #{inspect(MotionSensor.read(pin_sensor))}")
    if MotionSensor.read(pin_sensor) == true do
      Logger.debug("Movement detected!!")
      Buzzer.beep(pin_buzz, 0.25)
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

  def loop(pin_buzz, pin_sensor) do

    Logger.debug("Alarm activated")

    receive do
      :stop ->
        Logger.debug("Stopping...")
        exit(:shutdown)
    after
      300 -> :timeout
    end

    check_sensor(pin_buzz, pin_sensor)
    loop(pin_buzz, pin_sensor)

  end
end
