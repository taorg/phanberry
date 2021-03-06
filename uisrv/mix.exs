defmodule Uisrv.Mixfile do
  use Mix.Project

  def project do
    [
      app: :uisrv,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Uisrv.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.4"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.4"},
      {:sqlite_ecto2, "~> 2.2"},
      {:phoenix_html, "~> 2.12"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_active_link, "~> 0.2"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:sans_password, "~> 1.0"},
      {:guardian_trackable, "~> 0.1"},
      {:swoosh, "~> 0.2"},
      {:event_bus, "~> 1.5"},
      {:elixir_uuid, "~> 1.2"},
      {:faker, "~> 0.10", only: [:dev, :test]}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
