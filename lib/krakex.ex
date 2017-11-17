defmodule Krakex do
  @moduledoc """
  Documentation for Krakex.
  """

  alias Krakex.{Client, Public}

  def time do
    Public.request(client(), "Time")
  end

  def assets do
    Public.request(client(), "Assets")
  end

  def asset_pairs do
    Public.request(client(), "AssetPairs")
  end

  def ticker(pairs) when is_list(pairs) do
    Public.request(client(), "Ticker", params: [pair: pairs])
  end

  def ohlc(pair, opts \\ []) do
    Public.request(client(), "OHLC", params: [pair: pair] ++ opts)
  end

  def depth(pair, opts \\ []) do
    Public.request(client(), "Depth", params: [pair: pair] ++ opts)
  end

  def trades(pair, opts \\ []) do
    Public.request(client(), "Trades", params: [pair: pair] ++ opts)
  end

  def spread(pair, opts \\ []) do
    Public.request(client(), "Spread", params: [pair: pair] ++ opts)
  end

  defp client do
    Client.new()
  end
end
