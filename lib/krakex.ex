defmodule Krakex do
  @moduledoc """
  Documentation for Krakex.
  """

  alias Krakex.Client

  @api Application.get_env(:krakex, :api_mod, Krakex.API)

  def server_time(client \\ @api.public_client()) do
    @api.public_request(client, "Time")
  end

  def assets(client \\ @api.public_client()) do
    @api.public_request(client, "Assets")
  end

  def asset_pairs(client \\ @api.public_client()) do
    @api.public_request(client, "AssetPairs")
  end

  def ticker(client \\ @api.public_client(), pairs) when is_list(pairs) do
    @api.public_request(client, "Ticker", pair: pairs)
  end

  # An open-high-low-close chart (also OHLC) is a type of chart typically used to illustrate movements in the price of a financial instrument over time. Each vertical line on the chart shows the price range (the highest and lowest prices) over one unit of time, e.g., one day or one hour
  def ohlc(client \\ @api.public_client(), pair, opts \\ []) do
    @api.public_request(client, "OHLC", [pair: pair] ++ opts)
  end

  def depth(client \\ @api.public_client(), pair, opts \\ []) do
    @api.public_request(client, "Depth", [pair: pair] ++ opts)
  end

  def trades(client \\ @api.public_client(), pair, opts \\ []) do
    @api.public_request(client, "Trades", [pair: pair] ++ opts)
  end

  def spread(client \\ @api.public_client(), pair, opts \\ []) do
    @api.public_request(client, "Spread", [pair: pair] ++ opts)
  end

  def balance(client \\ @api.private_client()) do
    @api.private_request(client, "Balance")
  end

  def trade_balance(client \\ @api.private_client()) do
    @api.private_request(client, "TradeBalance")
  end

  def open_orders(client \\ @api.private_client()) do
    @api.private_request(client, "OpenOrders")
  end

  def closed_orders(client \\ @api.private_client(), opts \\ [])

  def closed_orders(%Client{} = client, opts) when is_list(opts) do
    @api.private_request(client, "ClosedOrders", opts)
  end

  def closed_orders(opts, []) do
    @api.private_request(@api.private_client(), "ClosedOrders", opts)
  end

  def query_orders(tx_ids, client \\ @api.private_client()) do
    @api.private_request(client, "QueryOrders", txid: tx_ids)
  end

  def trades_history(client \\ @api.private_client(), opts) do
    @api.private_request(client, "TradesHistory", opts)
  end

  def query_trades(client \\ @api.private_client(), tx_ids, opts) do
    @api.private_request(client, "QueryTrades", [txid: tx_ids] ++ opts)
  end

  def open_positions(client \\ @api.private_client(), tx_ids, opts) do
    @api.private_request(client, "OpenPositions", [txid: tx_ids] ++ opts)
  end

  def ledgers(client \\ @api.private_client(), opts) do
    @api.private_request(client, "Ledgers", opts)
  end

  def query_ledgers(client \\ @api.private_client(), ids) do
    @api.private_request(client, "QueryLedgers", id: ids)
  end

  def trade_volume(client \\ @api.private_client()) do
    @api.private_request(client, "TradeVolume", [])
  end

  # TODO: add_order, cancel_order
end
