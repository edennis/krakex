# Krakex

Elixir client for the [Kraken Bitcoin Exchange API](https://www.kraken.com/help/api)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `krakex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:krakex, "~> 0.1.0"}
  ]
end
```

## Configuration

```elixir
config :krakex,
  api_key: System.get_env("KRAKEN_API_KEY"),
  private_key: System.get_env("KRAKEN_PRIVATE_KEY")
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/krakex](https://hexdocs.pm/krakex).

