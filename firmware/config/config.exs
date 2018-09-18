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

# Set a mdns domain and node_name to be able to remsh into the device.
config :nerves_init_gadget,
  ifname: "wlan0",
  address_method: :dhcp,
  node_name: :phanberry1,
  mdns_domain: ":ptbsl.com",
  ssh_console_port: 22



# Sample HD44780 configuration for a 2x20 display connected to
# my Raspberry Pi0W. The 4 bit interface requires 6 GPIO pins
# which are managed by the driver:

 config :ex_lcd, lcd: %{
   rs: 22,
   en: 27,
   d4: 25,
   d5: 24,
   d6: 23,
   d7: 18,
   rows: 2,
   cols: 20,
   font_5x10: false
 }


import_config "#{Mix.Project.config()[:target]}.exs"
