defmodule Krakex do
  @moduledoc """
  Documentation for Krakex.
  """

  alias Krakex.{Client, Private, Public}

  defmodule MissingConfigError do
    defexception [:message]
  end

  def server_time(client \\ client()) do
    Public.request(client, "Time")
  end

  def assets(client \\ client()) do
    Public.request(client, "Assets")
  end

  def asset_pairs(client \\ client()) do
    Public.request(client, "AssetPairs")
  end

  def ticker(client \\ client(), pairs) when is_list(pairs) do
    Public.request(client, "Ticker", pair: pairs)
  end

  def ohlc(client \\ client(), pair, opts \\ []) do
    Public.request(client, "OHLC", [pair: pair] ++ opts)
  end

  def depth(client \\ client(), pair, opts \\ []) do
    Public.request(client, "Depth", [pair: pair] ++ opts)
  end

  def trades(client \\ client(), pair, opts \\ []) do
    Public.request(client, "Trades", [pair: pair] ++ opts)
  end

  def spread(client \\ client(), pair, opts \\ []) do
    Public.request(client, "Spread", [pair: pair] ++ opts)
  end

  def balance(client \\ private_client()) do
    Private.request(client, "Balance")
  end

  def trade_balance(client \\ private_client()) do
    Private.request(client, "TradeBalance")
  end

  def open_orders(client \\ private_client()) do
    Private.request(client, "OpenOrders")
  end

  def closed_orders(client \\ private_client()) do
    Private.request(client, "ClosedOrders")
  end

  defp client do
    Client.new()
  end

  defp private_client do
    config = Application.get_all_env(:krakex)

    case {config[:api_key], config[:private_key]} do
      {api_key, private_key} when is_binary(api_key) and is_binary(private_key) ->
        Client.new(config[:api_key], config[:private_key])

      _ ->
        raise MissingConfigError,
          message: """
          This API call requires an API key and a private key and I wasn't able to find them in your
          mix config. You need to define them like this:

          config :krakex,
            api_key: "KRAKEN_API_KEY",
            private_key: "KRAKEN_PRIVATE_KEY"
          """
    end
  end
end
