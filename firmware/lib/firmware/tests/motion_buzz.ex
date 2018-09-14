defmodule Firmware.Tests.MotionBuzz do
  require Logger
  alias Nerves.Grove.Sensor.MotionSensor
  alias Nerves.Grove.Buzzer


  @type input(buzz_pid, pin_buzz, pin_sensor) ::
          [{buzz_pid, pin_buzz, pin_sensor}]

  def start_alarm(pin_buzz, pin_sensor) do
    {:ok, buzz_pid} = Buzzer.start_link(pin_buzz)
    #input = {buzz_pid, pin_buzz, pin_sensor}

    task_pid =
      Task.start(fn ->
        loop(buzz_pid, pin_sensor)
      end)

    task_pid
  end

  def check_sensor(buzz_pid, pin_sensor) do
    Logger.debug("Sensor status #{inspect(MotionSensor.read(pin_sensor))}")
    if MotionSensor.read(pin_sensor) == 1 do
      Buzzer.beep(buzz_pid, 0.25)
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

  def loop(buzz_pid, pin_sensor) do
    check_sensor(buzz_pid, pin_sensor)
    Logger.debug("Alarm activated")

    receive do
      :stop ->
        Logger.debug("Stopping...")
        Process.sleep(100)
        exit(:shutdown)
    end

    Process.sleep(10)
    loop(buzz_pid, pin_sensor)

  end
end
