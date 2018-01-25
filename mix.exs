defmodule Krakex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :krakex,
      version: "0.1.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      source_url: github_url(),
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

  defp description() do
    "Elixir client for the Kraken Bitcoin Exchange API."
  end

  defp package() do
    [
      maintainers: ["Erick Dennis"],
      licenses: ["MIT"],
      links: %{"GitHub" => github_url()}
    ]
  end

  defp github_url do
    "https://github.com/edennis/krakex"
  end
end
