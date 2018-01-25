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

  @doc """
  Get server time.

  This is to aid in approximating the skew time between the server and client.

  Returns a map with the fields:

    * `"unixtime"` - as unix timestamp.
    * `"rfc1123"` - as RFC 1123 time format.

  ## Example response:

       {:ok, %{"rfc1123" => "Thu,  4 Jan 18 14:57:58 +0000", "unixtime" => 1515077878}}

  """
  @spec server_time(Client.t()) :: Krakex.API.response()
  def server_time(client \\ @api.public_client()) do
    @api.public_request(client, "Time")
  end

  @doc """
  Get asset info.

  Takes the following keyword options:

    * `:info` - info to retrieve. `"info"` (default)
    * `:aclass` - asset class. `"currency"` (default)
    * `:asset` - list of assets to get info on. Returns all (default)

  Returns a map of asset names and a map of their info with the fields:

    * `"altname"` - alternate name.
    * `"aclass"` - asset class.
    * `"decimals"` - scaling decimal places for record keeping.
    * `"display_decimals"` - scaling decimal places for output display.

  ## Example response:

      {:ok, %{"BCH" => %{"aclass" => "currency", "altname" => "BCH",
                         "decimals" => 10, "display_decimals" => 5}}}

  """
  @spec assets(Client.t(), keyword) :: Krakex.API.response()
  def assets(client \\ @api.public_client(), opts \\ [])

  def assets(%Client{} = client, opts) when is_list(opts) do
    @api.public_request(client, "Assets", opts)
  end

  def assets(opts, []) do
    @api.public_request(@api.public_client(), "Assets", opts)
  end

  @doc """
  Get tradable asset pairs.

  Takes the following keyword options:

    * `:info` - info to retrieve.
      * `"info"` - all info (default).
      * `"leverage"` - leverage info.
      * `"fees"` - fees schedule.
      * `"margin"` - margin info.
    * `:pair` - list of asset pairs to get info on. Returns all (default)

  Returns a map of asset pairs and a map of their info with the fields:

    * `"altname"` - alternate pair name.
    * `"aclass_base"` - asset class of base component.
    * `"base"` - asset id of base component.
    * `"aclass_quote"` - asset class of quote component.
    * `"quote"` - asset id of quote component.
    * `"lot"` - volume lot size.
    * `"pair_decimals"` - scaling decimal places for pair.
    * `"lot_decimals"` - scaling decimal places for volume.
    * `"lot_multiplier"` - amount to multiply lot volume by to get currency volume.
    * `"leverage_buy"` - array of leverage amounts available when buying.
    * `"leverage_sell"` - array of leverage amounts available when selling.
    * `"fees"` - fee schedule array in [volume, percent fee] tuples.
    * `"fees_maker"` - maker fee schedule array in [volume, percent fee] tuples (if on maker/taker).
    * `"fee_volume_currency"` - volume discount currency.
    * `"margin_call"` - margin call level.
    * `"margin_stop"` - stop-out/liquidation margin level.

  ## Example response:

      {:ok, %{"BCHEUR" => %{"aclass_base" => "currency", "aclass_quote" => "currency",
                            "altname" => "BCHEUR", "base" => "BCH", "fee_volume_currency" => "ZUSD",
                            "fees" => [[0, 0.26], [50000, 0.24], [100000, 0.22], [250000, 0.2],
                            [500000, 0.18], [1000000, 0.16], [2500000, 0.14], [5000000, 0.12],
                            [10000000, 0.1]],
                            "fees_maker" => [[0, 0.16], [50000, 0.14], [100000, 0.12], [250000, 0.1],
                            [500000, 0.08], [1000000, 0.06], [2500000, 0.04], [5000000, 0.02],
                            [10000000, 0]], "leverage_buy" => [], "leverage_sell" => [],
                            "lot" => "unit", "lot_decimals" => 8, "lot_multiplier" => 1,
                            "margin_call" => 80, "margin_stop" => 40, "pair_decimals" => 1,
                            "quote" => "ZEUR"}}

  """
  @spec asset_pairs(Client.t(), keyword) :: Krakex.API.response()
  def asset_pairs(client \\ @api.public_client(), opts \\ [])

  def asset_pairs(%Client{} = client, opts) when is_list(opts) do
    @api.public_request(client, "AssetPairs", opts)
  end

  def asset_pairs(opts, []) do
    @api.public_request(@api.public_client(), "AssetPairs", opts)
  end

  @doc """
  Get ticker information.

  Takes list of asset pairs to get info on.

  Returns a map of asset pairs and a map of their ticker info with the fields:

    * `"a"` - ask array(_price_, _whole lot volume_, _lot volume_).
    * `"b"` - bid array(_price_, _whole lot volume_, _lot volume_).
    * `"c"` - last trade closed array(_price_, _lot volume_).
    * `"v"` - volume array(_today_, _last 24 hours_).
    * `"p"` - volume weighted average price array(_today_, _last 24 hours_).
    * `"t"` - number of trades array(_today_, _last 24 hours_).
    * `"l"` - low array(_today_, _last 24 hours_).
    * `"h"` - high array(_today_, _last 24 hours_).
    * `"o"` - today's opening price.

  ## Example response:

      {:ok,
        %{"BCHEUR" => %{"a" => ["2034.800000", "1", "1.000"],
            "b" => ["2025.000000", "8", "8.000"], "c" => ["2025.000000", "0.03660000"],
            "h" => ["2140.000000", "2227.600000"],
            "l" => ["1942.000000", "1942.000000"], "o" => "2134.000000",
            "p" => ["2021.440397", "2051.549114"], "t" => [3824, 6704],
            "v" => ["1956.76538027", "4086.36386115"]}}}

  """
  @spec ticker(Client.t(), [binary]) :: Krakex.API.response()
  def ticker(client \\ @api.public_client(), pairs) when is_list(pairs) do
    @api.public_request(client, "Ticker", pair: pairs)
  end

  @doc """
  Get OHLC data.

  An open-high-low-close chart is a type of chart typically used to illustrate movements
  in the price of a financial instrument over time. Each vertical line on the chart shows
  the price range (the highest and lowest prices) over one unit of time, e.g., one day or
  one hour Takes list of asset pairs to get info on.

  Takes an asset pair and the following keyword options:

    * `:interval` - time frame interval in minutes. 1 (default), 5, 15, 30, 60, 240, 1440, 10080, 21600
    * `:since` - return committed OHLC data since given id (exclusive).

  Returns a map with the asset pair and a list of lists with the entries (_time_, _open_, _high_,
  _low_, _close_, _vwap_, _volume_, _count_) and:

    * `"last"` - id to be used as since when polling for new, committed OHLC data.

  Note: the last entry in the OHLC array is for the current, not-yet-committed frame and will
  always be present, regardless of the value of `:since`.

  ## Example response:

      {:ok,
        %{"BCHEUR" => [[1515037200, "2051.7", "2051.7", "2051.7", "2051.7", "0.0", "0.00000000", 0],
            [1515037260, "2051.7", "2051.7", "2045.0", "2045.0", "2045.0", "0.01500000", 1],
            [1515037320, "2045.0", "2050.8", "2045.0", "2050.8", "2050.7", "2.37135868", 2],
            [1515037380, "2050.8", "2050.8", "2050.8", "2050.8", "0.0", "0.00000000", 0],
            ...],
            "last" => 1515080280}}

  """
  @spec ohlc(Client.t(), binary, keyword) :: Krakex.API.response()
  def ohlc(client \\ @api.public_client(), pair, opts \\ [])

  def ohlc(%Client{} = client, pair, opts) when is_list(opts) do
    @api.public_request(client, "OHLC", [pair: pair] ++ opts)
  end

  def ohlc(pair, opts, []) do
    @api.public_request(@api.public_client(), "OHLC", [pair: pair] ++ opts)
  end

  @doc """
  Get order book.

  Returns the market depth for an asset pair.

  Takes an asset pair and the following keyword options:

    * `:count` - maximum number of asks/bids.

  Returns a map of the asset pair and a map of the info with the fields:

    * `"asks"` - ask side array of array entries (_price_, _volume_, _timestamp_).
    * `"bids"` - bid side array of array entries (_price_, _volume_, _timestamp_).

  ## Example response:

      {:ok,
          %{"BCHEUR" => %{"asks" => [["2033.900000", "4.937", 1515082275],
                                    ["2034.000000", "0.548", 1515081910],
                                    ["2034.500000", "0.005", 1515081281],
                                    ["2034.800000", "4.637", 1515082048]],
                          "bids" => [["2025.000000", "1.024", 1515081702],
                                    ["2022.200000", "0.140", 1515078885],
                                    ["2022.100000", "0.280", 1515078852],
                                    ["2021.400000", "0.248", 1515080222]]}}}

  """
  @spec depth(Client.t(), binary, keyword) :: Krakex.API.response()
  def depth(client \\ @api.public_client(), pair, opts \\ [])

  def depth(%Client{} = client, pair, opts) do
    @api.public_request(client, "Depth", [pair: pair] ++ opts)
  end

  def depth(pair, opts, []) do
    @api.public_request(@api.public_client(), "Depth", [pair: pair] ++ opts)
  end

  @doc """
  Get recent trades.

  Returns the trade data for an asset pair.

  Takes an asset pair and the following keyword options:

    * `:since` - return committed OHLC data since given id (exclusive).

  Returns a map with the asset pair and a list of lists with the entries (_price_, _volume_, _time_,
  _buy/sell_, _market/limit_, _miscellaneous_) and:

    * `"last"` - id to be used as since when polling for new trade data.

  ## Example response:

      {:ok,
        %{"BCHEUR" => [["2008.100000", "0.09000000", 1515066097.1379, "b", "m", ""],
                      ["2008.200000", "0.24850000", 1515066097.1663, "b", "m", ""],
                      ["2008.300000", "4.36233575", 1515066097.1771, "b", "m", ""],
                      ["2005.000000", "0.04107303", 1515066117.0598, "s", "l", ""],
                      ["2008.000000", "0.07700000", 1515066117.389, "b", "l", ""],
        "last" => "1515076587511702121"}}

  """
  @spec trades(Client.t(), binary, keyword) :: Krakex.API.response()
  def trades(client \\ @api.public_client(), pair, opts \\ [])

  def trades(%Client{} = client, pair, opts) do
    @api.public_request(client, "Trades", [pair: pair] ++ opts)
  end

  def trades(pair, opts, []) do
    @api.public_request(@api.public_client(), "Trades", [pair: pair] ++ opts)
  end

  @doc """
  Get recent spread data.

  Returns the spread data for an asset pair.

  Takes an asset pair and the following keyword options:

    * `:since` - return spread data since given id (inclusive).

  Returns a map with the asset pair and a list of lists with the entries
  (_time_, _bid_, _ask_) and:

    * `"last"` - id to be used as since when polling for new trade data.

  ## Example response:

      {:ok,
        %{"BCHEUR" => [[1515079584, "2025.000000", "2025.000000"],
                      [1515079584, "2025.000000", "2036.100000"],
                      [1515079594, "2025.000000", "2025.000000"],
                      [1515079596, "2025.000000", "2026.000000"],
                      [1515080461, "2025.500000", "2034.100000"],
                      [1515080462, "2025.000000", "2034.100000"]],
          "last" => 1515083299}}

  """
  @spec spread(Client.t(), binary, keyword) :: Krakex.API.response()
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
