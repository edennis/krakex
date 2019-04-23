defmodule Krakex.Mixfile do
  use Mix.Project

  @version "0.4.0"

  def project do
    [
      app: :krakex,
      version: @version,
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      docs: docs(),
      source_url: github_url(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
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
      {:httpoison, "~> 1.4"},
      {:poison, "~> 3.1"},
      {:excoveralls, "~> 0.10", only: :test},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false},
      {:dialyxir, "~> 0.5.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "Krakex",
      source_ref: "v#{@version}",
      source_url: github_url()
    ]
  end

  defp description() do
    "Elixir client for the Kraken Bitcoin Exchange API."
  end

  defp package() do
    [
      files: ["README.md", "LICENSE", "mix.exs", "lib/**/*.ex"],
      maintainers: ["Erick Dennis"],
      licenses: ["MIT"],
      links: %{"GitHub" => github_url()}
    ]
  end

  defp github_url do
    "https://github.com/edennis/krakex"
  end
end
