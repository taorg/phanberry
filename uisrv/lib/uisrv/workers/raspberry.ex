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
    Logger.metadata
    Logger.debug("#{inspect(topic)}--#{inspect(id)}--#{inspect(state)}--#{inspect(event)}")
    EventBus.mark_as_completed({EventBus.Logger, topic, id})
    {:noreply, state}
  end
end
