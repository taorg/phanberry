defmodule Uisrv.Application do
  use Application
  use Ecto.Migration
  require Logger
  alias Uisrv.EventBus.Supervisors.Raspberry, as: RaspberrySupervisor

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @otp_app Mix.Project.config()[:app]

  def start(_type, _args) do
    import Supervisor.Spec

    :ok = setup_db!()
    Logger.info("setup_db!() succsessfully started")

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Uisrv.Repo, []),
      # Start the endpoint when the application starts
      supervisor(UisrvWeb.Endpoint, []),
      # Start your own worker by calling: Uisrv.Worker.start_link(arg1, arg2, arg3)
      # worker(Uisrv.Worker, [arg1, arg2, arg3]),
      supervisor(RaspberrySupervisor, [], id: make_ref(), restart: :permanent)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Uisrv.EventBus.Supervisor]
    link = Supervisor.start_link(children, opts)
    EventBus.subscribe({Uisrv.EventBus.Workers.Raspberry, ["^rpbrr_msg_tx$","^rpbrr_error$"]})
    link
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    UisrvWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp setup_db! do
    repos = Application.get_env(@otp_app, :ecto_repos)

    for repo <- repos do
      if Application.get_env(@otp_app, repo)[:adapter] == Elixir.Sqlite.Ecto2 do
        setup_repo!(repo)
        migrate_repo!(repo)
      end
    end

    :ok
  end

  defp setup_repo!(repo) do
    db_file = Application.get_env(@otp_app, repo)[:database]

    unless File.exists?(db_file) do
      :ok = repo.__adapter__.storage_up(repo.config)
    end
  end

  defp migrate_repo!(repo) do
    opts = [all: true]
    {:ok, pid, apps} = Mix.Ecto.ensure_started(repo, opts)

    migrator = &Ecto.Migrator.run/4
    pool = repo.config[:pool]
    migrations_path = Path.join([:code.priv_dir(@otp_app) |> to_string, "repo", "migrations"])

    migrated =
      if function_exported?(pool, :unboxed_run, 2) do
        pool.unboxed_run(repo, fn -> migrator.(repo, migrations_path, :up, opts) end)
      else
        migrator.(repo, migrations_path, :up, opts)
      end

    # pid &&
    repo.stop(pid)
    Mix.Ecto.restart_apps_if_migrated(apps, migrated)
  end
end
