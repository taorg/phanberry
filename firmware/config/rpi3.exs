# Configuration for the Raspberry Pi 3 (target rpi3)
use Mix.Config

# Configure your database
config :uisrv, Uisrv.Repo,
  adapter: Sqlite.Ecto2,
  database: "/root/#{Mix.env()}.sqlite3"

# General application configuration
config :uisrv,
  ecto_repos: [Uisrv.Repo]

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
    File.read!(Path.join(System.user_home!(), ".ssh/id_rsa.pub"))
  ]

# Set a mdns domain and node_name to be able to remsh into the device.
config :nerves_init_gadget,
  ifname: "wlan0",
  node_name: :firmware,
  mdns_domain: ":firmware.local",
  ssh_console_port: 22
