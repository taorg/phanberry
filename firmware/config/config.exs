# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.
config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"
#   fwup_conf: "config/fwup.conf"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.
config :shoehorn,
  init: [:nerves_runtime, :nerves_init_gadget],
  app: Mix.Project.config()[:app]

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# Add the RingLogger backend. This removes the
# default :console backend.
config :logger, backends: [RingLogger]

# Set the number of messages to hold in the circular buffer
config :logger, RingLogger, max_size: 500
config :logger, level: :debug

key_mgmt = System.get_env("NERVES_NETWORK_KEY_MGMT") || "WPA-PSK"

config :nerves_network,
  regulatory_domain: "ES"

config :nerves_network, :default,
  wlan0: [
    ipv4_address_method: :dhcp,
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
  address_method: :dhcp,
  node_name: :phanberry1,
  mdns_domain: ":ptbsl.com",
  ssh_console_port: 22

import_config "#{Mix.Project.config()[:target]}.exs"
