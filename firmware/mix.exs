defmodule Firmware.MixProject do
  use Mix.Project

  @target System.get_env("MIX_TARGET") || "host"

  def project do
    [
      app: :firmware,
      version: "0.1.0",
      elixir: "~> 1.6",
      target: @target,
      archives: [nerves_bootstrap: "~> 1.3.1"],
      deps_path: "deps/#{@target}",
      build_path: "_build/#{@target}",
      lockfile: "mix.lock.#{@target}",
      start_permanent: Mix.env() == :prod,
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps()
    ]
  end

  # Starting nerves_bootstrap adds the required aliases to Mix.Project.config()
  # Aliases are only added if MIX_TARGET is set.
  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Firmware.Application, []},
      mod: {Firmware.Network, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nerves, "~> 1.3.1", runtime: false},
      {:shoehorn, "~> 0.4"},
      {:ring_logger, "~> 0.5"}
    ] ++ deps(@target)
  end

  # Specify target specific dependencies
  defp deps("host"), do: [{:event_bus, "~> 1.5"}, {:elixir_uuid, "~> 1.2"}]

  defp deps(target) do
    [
      {:nerves_init_gadget, "~> 0.5"},
      {:nerves_firmware_ssh, "~> 0.3"},
      {:nerves_runtime, "~> 0.8"},
      {:uisrv, path: "../uisrv"},
      {:event_bus, "~> 1.5"},
      {:elixir_uuid, "~> 1.2"},
      {:elixir_ale, "~> 1.1"},
      {:pigpiox, path: "../../pigpiox"},
      # {:nerves_grove, github: "Manolets/nerves_grove"},
      {:nerves_grove, path: "../../nerves_grove"},
      {:nerves_dht, git: "https://github.com/visciang/nerves_dht.git", tag: "1.1.4"}
      # {:ex_lcd, path: "../../ex_lcd"}
    ] ++ system(target)
  end

  defp system("rpi"), do: [{:nerves_system_rpi, "~> 1.0", runtime: false}]
  defp system("rpi0"), do: [{:nerves_system_rpi0, "~> 1.0", runtime: false}]
  defp system("rpi2"), do: [{:nerves_system_rpi2, "~> 1.0", runtime: false}]
  defp system("rpi3"), do: [{:nerves_system_rpi3, "~> 1.5.0", runtime: false}]

  # defp system("phanberry_rpi3"),
  #   do: [{:custom_rpi3, path: "../phanberry_system_rpi3", runtime: false}]

  defp system("bbb"), do: [{:nerves_system_bbb, "~> 1.0", runtime: false}]
  defp system("ev3"), do: [{:nerves_system_ev3, "~> 1.0", runtime: false}]
  defp system("x86_64"), do: [{:nerves_system_x86_64, "~> 1.0", runtime: false}]
  defp system(target), do: Mix.raise("Unknown MIX_TARGET: #{target}")
end
