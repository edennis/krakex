# Krakex

[![Build Status](https://github.com/edennis/krakex/workflows/Elixir%20CI/badge.svg)](https://github.com/edennis/krakex/actions/workflows/elixir.yml)
[![Coverage Status](https://coveralls.io/repos/github/edennis/krakex/badge.svg?branch=master)](https://coveralls.io/github/edennis/krakex?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/v/krakex.svg)](https://hex.pm/packages/krakex)

Elixir client for the [Kraken Bitcoin Exchange API](https://www.kraken.com/help/api)

> Note that this README refers to the `master` branch of Krakex, not the latest
  released version on Hex. See [the documentation](http://hexdocs.pm/krakex) for
  the documentation of the version you're using.

## Installation

The package can be installed by adding `krakex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:krakex, "~> 0.4.1}
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

## TODO

### Private user funding calls

- [ ] [`withdraw/5`](https://www.kraken.com/help/api#withdraw-funds)
- [ ] [`withdraw_status/3`](https://www.kraken.com/help/api#withdraw-status)
- [ ] [`withdraw_cancel/4`](https://www.kraken.com/help/api#withdraw-cancel)

## Contributing

1. Fork it (https://github.com/edennis/krakex/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Copyright (c) 2018 Erick Dennis
