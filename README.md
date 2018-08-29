# Add new user

This is the firmware module, part of Phantaberry project, develop with Nerves framework in Elixir language.
It is intended to run on a Raspberry pi3 so `MIX_TARGET=rpi3`

## Targets

Nerves applications produce images for hardware targets based on the
`MIX_TARGET` environment variable. If `MIX_TARGET` is unset, `mix` builds an
image that runs on the host (e.g., your laptop). This is useful for executing
logic tests, running utilities, and debugging. Other targets are represented by
a short name like `rpi3` that maps to a Nerves system image for that platform.
All of this logic is in the generated `mix.exs` and may be customized. For more
information about targets see:

<https://hexdocs.pm/nerves/targets.html#content>

## Getting Started