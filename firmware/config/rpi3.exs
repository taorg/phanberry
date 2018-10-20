# Configuration for the Raspberry Pi 3 (target rpi3)
use Mix.Config

# Event bus topics
config :event_bus,
  topics: [
    :rpbrr_msg_tx,
    :rpbrr_cmd_rx,
    :rpbrr_error,
    :phx_msg_rx,
    :phx_cmd_tx,
    :jstick_tx_event,
    :jstick_tx_obj
  ],
  # integer
  ttl: 30_000_000,
  # atom
  time_unit: :microsecond

#
# PHOENIX-PHOENIX-PHOENIX-PHOENIX-PHOENIX-PHOENIX-PHOENIX-PHOENIX-PHOENIX-PHOENIX-PHOENIX-PHOENIX-PHOENIX-PHOENIX
# PHOENIX-PHOENIX-PHOENIX-PHOENIX-PHOENIX-PHOENIX-PHOENIX-PHOENIX-PHOENIX-PHOENIX-PHOENIX-PHOENIX-PHOENIX-PHOENIX
#
# Configure your database
config :uisrv, Uisrv.Repo,
  adapter: Sqlite.Ecto2,
  database: "/root/#{Mix.env()}.sqlite3"

# General application configuration
config :uisrv,
  ecto_repos: [Uisrv.Repo]

# Phoenix Endpoint configuration
config :uisrv, UisrvWeb.Endpoint,
  # This ip should be a public domain for an internet connected Raspberry
  # For local test we fix our DHCP server to assing this ip to Raspberry's device wlan0
  url: [host: "192.168.1.50"],
  http: [port: 80],
  secret_key_base: "s+p9jABrjMUuISSfH5VfOC3RR00QM9NQLBzUZ9VLN7IQN52HUjsNuShvsAi5qb1U",
  root: Path.dirname(__DIR__),
  server: true,
  render_errors: [view: UisrvWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Nerves.PubSub, adapter: Phoenix.PubSub.PG2],
  code_reloader: false

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

config :uisrv, :defaults, wrap_tag: :li
