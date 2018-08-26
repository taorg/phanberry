defmodule Firmware.Ectorepo do
  use Ecto.Migration
  require Logger

  # @otp_app Mix.Project.config()[:app]
  @otp_app Mix.Project.config()[:target]

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    :ok = setup_db!()
    Logger.info("setup_db!() succsessfully started")

    children = [
      supervisor(Uisrv.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: Ectorepo.Supervisor]
    Supervisor.start_link(children, opts)
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

    pid && repo.stop(pid)
    Mix.Ecto.restart_apps_if_migrated(apps, migrated)
  end
end
