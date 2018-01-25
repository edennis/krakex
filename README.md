# Krakex

[![Build Status](https://travis-ci.org/edennis/krakex.svg?branch=master)](https://travis-ci.org/edennis/krakex)
[![Coverage Status](https://coveralls.io/repos/github/edennis/krakex/badge.svg?branch=master)](https://coveralls.io/github/edennis/krakex?branch=master)

Elixir client for the [Kraken Bitcoin Exchange API](https://www.kraken.com/help/api)

> Note that this README refers to the `master` branch of Krakex, not the latest
  released version on Hex. See [the documentation](http://hexdocs.pm/krakex) for
  the documentation of the version you're using.

## Installation

The package can be installed by adding `krakex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:krakex, "~> 0.1.0"}
  ]
end
```

## Configuration

The Kraken API consists of public and private calls. While you can use the public API as you like,
you'll need to create an account and get yourself an API key if you want to do more. To use the
private API you'll need to add some configuration to your Mix config:

```elixir
config :krakex,
  api_key: System.get_env("KRAKEN_API_KEY"),
  private_key: System.get_env("KRAKEN_PRIVATE_KEY")
```

## Usage

The entire functionality of the API can be accessed via the `Krakex` module. To get started just
configure your API credentials as described above and call the functions:

```elixir
iex(1)> Krakex.balance()
{:ok,
 %{"BCH" => "0.0000000000", "XETH" => "0.0000000000", "ZEUR" => "50.00"}}
```

If you need to use multiple Kraken accounts in your application this can be achieved by explicitly
defining `Krakex.Client` structs and passing them as the first argument to any of the functions
defined in the `Krakex` module:

```elixir
client1 = Krakex.Client.new("api_key1", "secret1")
client2 = Krakex.Client.new("api_key2", "secret2")

balance1 = client1 |> Krakex.trade_balance(asset: "ZUSD")
balance2 = client2 |> Krakex.trade_balance(asset: "EUR")
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/krakex](https://hexdocs.pm/krakex).

