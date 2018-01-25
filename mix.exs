defmodule Krakex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :krakex,
      version: "0.1.0",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.1"},
      {:excoveralls, "~> 0.8", only: :test},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false},
      {:dialyxir, "~> 0.5.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false}
    ]
  end
end
