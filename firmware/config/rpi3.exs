# Configuration for the Raspberry Pi 3 (target rpi3)
use Mix.Config

key_mgmt = System.get_env("NERVES_NETWORK_KEY_MGMT") || "WPA-PSK"

config :nerves_network,
  regulatory_domain: "ES"

config :nerves_network, :default,
  wlan0: [
    ssid: System.get_env("NERVES_NETWORK_SSID"),
    psk: System.get_env("NERVES_NETWORK_PSK"),
    key_mgmt: String.to_atom(key_mgmt)
  ],
  eth0: [
    ipv4_address_method: :dhcp
  ]

# Uncomment the following line for the interface you intend to use,
# if not the wired :eth0 interface.
config :firmware, interface: :wlan0
# config :firmware, interface: :eth0
# config :firmware, interface: :usb0

# Nerves.Firmware.SSH An infrastruction to support "over-the-air" firmware updates with Nerves by using ssh
config :nerves_firmware_ssh,
  authorized_keys: [
    File.read!(Path.join(System.user_home!(), ".skm/taorg-rbrr-dev/id_rsa.pub")),
    File.read!(Path.join(System.user_home!(), ".skm/Mlopezc-rrbp3/id_rsa.pub")),
    File.read!(Path.join(System.user_home!(), ".skm/johannrbpi/id_rsa.pub"))
  ]

# Set a mdns domain and node_name to be able to remsh into the device.
config :nerves_init_gadget,
  ifname: "wlan0",
  node_name: :firmware,
  mdns_domain: ":firmware.local",
  ssh_console_port: 22

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
