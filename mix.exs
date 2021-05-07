defmodule AuditKazoo.MixProject do
  use Mix.Project

  def project do
    [
      app: :audit_kazoo,
      version: "0.1.0",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools, :httpoison],
      mod: {AuditKazoo.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      { :elixir_uuid, "~> 1.2" },
      {:wallaby, "~> 0.28.0", runtime: false, only: :test},
      {:plug_cowboy, "~> 2.1"},
      {:poison, "~> 4.0"},
      {:httpoison, "~> 1.8"},
      {:configparser_ex, "~> 4.0"},
      {:websockex, "~> 0.4.2"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
