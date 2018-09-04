defmodule Uisrv.Workers.Raspberry do
  use GenServer
  require Logger

  ## Public api

  @doc """
  Process event
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
  def init(_opts),
    do: {:ok, nil}

  @doc false
  def handle_cast({topic, id}, state) do
    event = EventBus.fetch_event({topic, id})
    EventBus.mark_as_completed({__MODULE__, topic, id})

    Logger.debug("topic->#{inspect(topic)}
      -id->#{inspect(id)}
      -state->#{inspect(state)}
      -event->#{inspect(event)}
      -state->#{inspect(state)}")

    {:noreply, state}
  end

end
