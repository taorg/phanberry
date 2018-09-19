defmodule Uisrv.Supervisors.Raspberry do
  @moduledoc """
  A supervisor for Raspberry
  """

  use Supervisor
  alias Uisrv.Workers.RaspberryConsummer, as: RaspberryWorker

  @doc false
  def start_link,
    do: Supervisor.start_link(__MODULE__, [], name: __MODULE__)

  @doc false
  def init([]) do
    children = [
      worker(RaspberryWorker, [], id: make_ref(), restart: :permanent)
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]

    supervise(children, opts)
  end
end
