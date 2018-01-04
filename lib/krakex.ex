defmodule Krakex do
  @moduledoc """
  Kraken API Client.

  The Kraken API is divided into several sections:

  ## Public market data

    * `server_time/1` - Get server time.
    * `assets/2` - Get asset info.
    * `asset_pairs/2` - Get tradable asset pairs.
    * `ticker/2` - Get ticker information.
    * `ohlc/3` - Get OHLC data.
    * `depth/3` - Get order book.
    * `trades/3` - Get recent trades.
    * `spread/3` - Get recent spread data.

  ## Private user data

    * `balance/1` - Get account balance.
    * `trade_balance/2` - Get trade balance.
    * `open_orders/2` - Get open orders.
    * `closed_orders/2` - Get closed orders.
    * `query_orders/3` - Query orders info.
    * `trades_history/2` - Get trades history.
    * `query_trades/2` - Query trades info.
    * `open_positions/2` - Get open positions.
    * `ledgers/2` - Get ledgers info.
    * `query_ledgers/2` - Query ledgers.
    * `trade_volume/2` - Get trade volume.

  ## Private user trading

    * `add_order/5` (not implemented) - Add standard order.
    * `cancel_order/2` (not implemented) - Cancel open order.

  ## Private user funding

    * `deposit_methods/3` (not implemented) - Get deposit methods.
    * `deposit_addresses/4` (not implemented) - Get deposit addresses.
    * `deposit_status/4` (not implemented) - Get status of recent deposits.
    * `withdraw_info/5` (not implemented) - Get withdrawal information.
    * `withdraw/5` (not implemented) - Withdraw funds.
    * `withdraw_status/3` (not implemented) - Get status of recent withdrawals.
    * `withdraw_cancel/4` (not implemented) - Request withdrawal cancelation.

  """

  alias Krakex.Client

  @api Application.get_env(:krakex, :api_mod, Krakex.API)

  def server_time(client \\ @api.public_client()) do
    @api.public_request(client, "Time")
  end

  def assets(client \\ @api.public_client(), opts \\ [])

  def assets(%Client{} = client, opts) when is_list(opts) do
    @api.public_request(client, "Assets", opts)
  end

  def assets(opts, []) do
    @api.public_request(@api.public_client(), "Assets", opts)
  end

  def asset_pairs(client \\ @api.public_client(), opts \\ [])

  def asset_pairs(%Client{} = client, opts) when is_list(opts) do
    @api.public_request(client, "AssetPairs", opts)
  end

  def asset_pairs(opts, []) do
    @api.public_request(@api.public_client(), "AssetPairs", opts)
  end

  def ticker(client \\ @api.public_client(), pairs) when is_list(pairs) do
    @api.public_request(client, "Ticker", pair: pairs)
  end

  # An open-high-low-close chart (also OHLC) is a type of chart typically used to illustrate movements in the price of a financial instrument over time. Each vertical line on the chart shows the price range (the highest and lowest prices) over one unit of time, e.g., one day or one hour
  def ohlc(client \\ @api.public_client(), pair, opts \\ [])

  def ohlc(%Client{} = client, pair, opts) when is_list(opts) do
    @api.public_request(client, "OHLC", [pair: pair] ++ opts)
  end

  def ohlc(pair, opts, []) do
    @api.public_request(@api.public_client(), "OHLC", [pair: pair] ++ opts)
  end

  def depth(client \\ @api.public_client(), pair, opts \\ [])

  def depth(%Client{} = client, pair, opts) do
    @api.public_request(client, "Depth", [pair: pair] ++ opts)
  end

  def depth(pair, opts, []) do
    @api.public_request(@api.public_client(), "Depth", [pair: pair] ++ opts)
  end

  def trades(client \\ @api.public_client(), pair, opts \\ [])

  def trades(%Client{} = client, pair, opts) do
    @api.public_request(client, "Trades", [pair: pair] ++ opts)
  end

  def trades(pair, opts, []) do
    @api.public_request(@api.public_client(), "Trades", [pair: pair] ++ opts)
  end

  def spread(client \\ @api.public_client(), pair, opts \\ [])

  def spread(%Client{} = client, pair, opts) do
    @api.public_request(client, "Spread", [pair: pair] ++ opts)
  end

  def spread(pair, opts, []) do
    @api.public_request(@api.public_client(), "Spread", [pair: pair] ++ opts)
  end

  def balance(client \\ @api.private_client()) do
    @api.private_request(client, "Balance")
  end

  def trade_balance(client \\ @api.private_client(), opts \\ [])

  def trade_balance(%Client{} = client, opts) do
    @api.private_request(client, "TradeBalance", opts)
  end

  def trade_balance(opts, []) do
    @api.private_request(@api.private_client(), "TradeBalance", opts)
  end

  def open_orders(client \\ @api.private_client(), opts \\ [])

  def open_orders(%Client{} = client, opts) when is_list(opts) do
    @api.private_request(client, "OpenOrders", opts)
  end

  def open_orders(opts, []) do
    @api.private_request(@api.private_client(), "OpenOrders", opts)
  end

  def closed_orders(client \\ @api.private_client(), opts \\ [])

  def closed_orders(%Client{} = client, opts) when is_list(opts) do
    @api.private_request(client, "ClosedOrders", opts)
  end

  def closed_orders(opts, []) do
    @api.private_request(@api.private_client(), "ClosedOrders", opts)
  end

  def query_orders(client \\ @api.private_client(), tx_ids, opts \\ [])

  def query_orders(%Client{} = client, tx_ids, opts) when is_list(opts) do
    @api.private_request(client, "QueryOrders", [txid: tx_ids] ++ opts)
  end

  def query_orders(tx_ids, opts, []) do
    @api.private_request(@api.private_client(), "QueryOrders", [txid: tx_ids] ++ opts)
  end

  def trades_history(client \\ @api.private_client(), offset, opts \\ [])

  def trades_history(%Client{} = client, offset, opts) do
    @api.private_request(client, "TradesHistory", [ofs: offset] ++ opts)
  end

  def trades_history(offset, opts, []) do
    @api.private_request(@api.private_client(), "TradesHistory", [ofs: offset] ++ opts)
  end

  def query_trades(client \\ @api.private_client(), tx_ids, opts \\ [])

  def query_trades(%Client{} = client, tx_ids, opts) when is_list(opts) do
    @api.private_request(client, "QueryTrades", [txid: tx_ids] ++ opts)
  end

  def query_trades(tx_ids, opts, []) do
    @api.private_request(@api.private_client(), "QueryTrades", [txid: tx_ids] ++ opts)
  end

  def open_positions(client \\ @api.private_client(), tx_ids, opts \\ [])

  def open_positions(%Client{} = client, tx_ids, opts) when is_list(opts) do
    @api.private_request(client, "OpenPositions", [txid: tx_ids] ++ opts)
  end

  def open_positions(tx_ids, opts, []) do
    @api.private_request(@api.private_client(), "OpenPositions", [txid: tx_ids] ++ opts)
  end

  def ledgers(client \\ @api.private_client(), offset, opts \\ [])

  def ledgers(%Client{} = client, offset, opts) do
    @api.private_request(client, "Ledgers", [ofs: offset] ++ opts)
  end

  def ledgers(offset, opts, []) do
    @api.private_request(@api.private_client(), "Ledgers", [ofs: offset] ++ opts)
  end

  def query_ledgers(client \\ @api.private_client(), ledger_ids) do
    @api.private_request(client, "QueryLedgers", id: ledger_ids)
  end

  def trade_volume(client \\ @api.private_client(), pairs, opts \\ [])

  def trade_volume(%Client{} = client, pairs, opts) when is_list(opts) do
    @api.private_request(client, "TradeVolume", [pair: pairs] ++ opts)
  end

  def trade_volume(pairs, opts, []) do
    @api.private_request(@api.private_client(), "TradeVolume", [pair: pairs] ++ opts)
  end
end
