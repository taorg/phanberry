# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configure your database
config :uisrv, Uisrv.Repo,
  adapter: Sqlite.Ecto2,
  database: "./#{Mix.env()}.sqlite3"

# General application configuration
config :uisrv,
  ecto_repos: [Uisrv.Repo]

# Configures the endpoint
config :uisrv, UisrvWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "s+p9jABrjMUuISSfH5VfOC3RR00QM9NQLBzUZ9VLN7IQN52HUjsNuShvsAi5qb1U",
  render_errors: [view: UisrvWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Uisrv.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Guardian
config :uisrv, Uisrv.Auth.Guardian,
  issuer: "uisrv",
  secret_key: "Utahl6iK5poGWhrnunoDCLADNg3v4S0/XU4A4e2IjOfZvRZW3XX4TResib63ENiW",
  token_ttl: %{
    "magic" => {30, :minutes},
    "access" => {1, :days}
  }

config :uisrv, Uisrv.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: System.get_env("SEND_GRID_PHANTABERRY_KEY")

config :event_bus,
  topics: [:rpbrr_msg_rx,:rpbrr_cmd_rx,:rpbrr_error,
           :phx_msg_rx,:phx_cmd_tx,:phx_error],
  # integer
  ttl: 30_000_000,
  # atom
  time_unit: :microsecond

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
