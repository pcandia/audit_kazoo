defmodule AuditKazoo.MixProject do
  use Mix.Project

  def project do
    [
      app: :audit_kazoo,
      version: "0.1.0",
      elixir: "~> 1.10",
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
      {:wallaby, "~> 0.28.0", runtime: false, only: :test},
      {:plug_cowboy, "~> 2.1"},
      {:poison, "~> 4.0"},
      {:httpoison, "~> 1.8"}
    ]
  end
end
