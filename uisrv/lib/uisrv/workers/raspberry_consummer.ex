defmodule Uisrv.Workers.RaspberryConsummer do
  use GenServer
  require Logger

  ## Public api

  @doc """
  All modules that implements process/1 function can be a consumer for event_bus events.
  The important thing while consuming events is not to block other events and consumers.
  It is always good idea to use a non-blocking way to handle events.
  Majority of the processes use GenServer abstraction to implement concurrent processing.

  Here is a working sample of a simple consumer:
  """
  def process({_topic, _id} = event_shadow) do
    GenServer.cast(__MODULE__, event_shadow)
    :ok
  end

  ## Callbacks

  @doc false
  def start_link,
    do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)

  @doc false
  def init(_opts) do
    {:ok, []}
  end

  @doc false
  def handle_cast({topic, id}, state) do
    # Fetch event
    event = EventBus.fetch_event({topic, id})

    # Do sth with the event
    # Or just log for the sample
    Logger.info("I am handling the event with GenServer #{__MODULE__}")
    Logger.info(fn -> inspect(event) end)
    Logger.debug("topic->#{inspect(topic)}
      -id->#{inspect(id)}
      -state->#{inspect(state)}
      -event->#{inspect(event)}
      -state->#{inspect(state)}")

    # mark the event as completed for this consumer
    EventBus.mark_as_completed({__MODULE__, topic, id})
    {:noreply, state}
  end
end
