defmodule Krakex do
  @moduledoc """
  Documentation for Krakex.
  """

  alias Krakex.{Client, Private, Public}

  def server_time do
    Public.request(client(), "Time")
  end

  def assets do
    Public.request(client(), "Assets")
  end

  def asset_pairs do
    Public.request(client(), "AssetPairs")
  end

  def ticker(pairs) when is_list(pairs) do
    Public.request(client(), "Ticker", pair: pairs)
  end

  def ohlc(pair, opts \\ []) do
    Public.request(client(), "OHLC", [pair: pair] ++ opts)
  end

  def depth(pair, opts \\ []) do
    Public.request(client(), "Depth", [pair: pair] ++ opts)
  end

  def trades(pair, opts \\ []) do
    Public.request(client(), "Trades", [pair: pair] ++ opts)
  end

  def spread(pair, opts \\ []) do
    Public.request(client(), "Spread", [pair: pair] ++ opts)
  end

  def balance(client \\ client()) do
    Private.request(client, "Balance")
  end

  def trade_balance(client \\ client()) do
    Private.request(client, "TradeBalance")
  end

  def open_orders(client \\ client()) do
    Private.request(client, "OpenOrders")
  end

  def closed_orders(client \\ client()) do
    Private.request(client, "ClosedOrders")
  end

  defp client do
    config = Application.get_all_env(:krakex)

    case {config[:api_key], config[:private_key]} do
      {api_key, private_key} when is_binary(api_key) and is_binary(private_key) ->
        Client.new(config[:api_key], config[:private_key])

      _ ->
        Client.new()
    end
  end
end
