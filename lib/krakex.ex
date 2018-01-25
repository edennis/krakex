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
    * `trades_history/3` - Get trades history.
    * `query_trades/3` - Query trades info.
    * `open_positions/3` - Get open positions.
    * `ledgers/3` - Get ledgers info.
    * `query_ledgers/2` - Query ledgers.
    * `trade_volume/2` - Get trade volume.

  ## Private user trading

    * `add_order/6` - Add standard order.
    * `cancel_order/2` - Cancel open order.

  ## Private user funding

    * `deposit_methods/3` - Get deposit methods.
    * `deposit_addresses/4` (not implemented) - Get deposit addresses.
    * `deposit_status/4` (not implemented) - Get status of recent deposits.
    * `withdraw_info/5` - Get withdrawal information.
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

  @doc """
  Get account balance.

  Returns a map with the asset names and balance amount.

  ## Example response:

      {:ok, %{"XXBT" => "0.0400000000", "XXRP" => "160.00000000", "ZEUR" => "67.6613"}}

  """
  @spec balance(Client.t()) :: Krakex.API.response()
  def balance(client \\ @api.private_client()) do
    @api.private_request(client, "Balance")
  end

  @doc """
  Get trade balance.

  Takes the following keyword options:

    * `:aclass` - asset class. `"currency"` (default)
    * `:asset` - base asset used to determine balance. `"ZUSD"` (default)

  Returns a map with the fields:

    * `"eb"` - equivalent balance (combined balance of all currencies).
    * `"tb"` - trade balance (combined balance of all equity currencies).
    * `"m"` - margin amount of open positions.
    * `"n"` - unrealized net profit/loss of open positions.
    * `"c"` - cost basis of open positions.
    * `"v"` - current floating valuation of open positions.
    * `"e"` - equity = trade balance + unrealized net profit/loss.
    * `"mf"` - free margin = equity - initial margin (maximum margin available to open new positions).
    * `"ml"` - margin level = (equity / initial margin) * 100.

  Note: Rates used for the floating valuation is the midpoint of the best bid and ask prices.

  ## Example response:

      {:ok,
        %{"c" => "0.0000", "e" => "725.4974", "eb" => "1177.9857", "m" => "0.0000",
          "mf" => "725.4974", "n" => "0.0000", "tb" => "725.4974", "v" => "0.0000"}}

  """
  @spec trade_balance(Client.t(), keyword) :: Krakex.API.response()
  def trade_balance(client \\ @api.private_client(), opts \\ [])

  def trade_balance(%Client{} = client, opts) do
    @api.private_request(client, "TradeBalance", opts)
  end

  def trade_balance(opts, []) do
    @api.private_request(@api.private_client(), "TradeBalance", opts)
  end

  @doc """
  Get open orders.

  Takes the following keyword options:

    * `:trades` - whether or not to include trades in output. `false` (default)
    * `:userref` - restrict results to given user reference id.

  Returns a map with the txid as the key and the value is a map with the fields:

    * `"refid"` - Referral order transaction id that created this order.
    * `"userref"` - user reference id.
    * `"status"` - status of order:
      * `"pending"` - order pending book entry.
      * `"open"` - open order.
      * `"closed"` - closed order.
      * `"canceled"` - order cancelled.
      * `"expired"` - order expired.
    * `"opentm"` - unix timestamp of when order was placed.
    * `"starttm"` - unix timestamp of order start time (or 0 if not set).
    * `"expiretm"` - unix timestamp of order end time (or 0 if not set).
    * `"descr"` - order description info:
      * `"pair"` - asset pair.
      * `"type"` - type of order (buy/sell).
      * `"ordertype"` - order type (See Add standard order).
      * `"price"` - primary price.
      * `"price2"` - secondary price.
      * `"leverage"` - amount of leverage.
      * `"order"` - order description.
      * `"close"` - conditional close order description (if conditional close set).
    * `"vol"` - volume of order (base currency unless viqc set in oflags).
    * `"vol_exec"` - volume executed (base currency unless viqc set in oflags).
    * `"cost"` - total cost (quote currency unless unless viqc set in oflags).
    * `"fee"` - total fee (quote currency).
    * `"price"` - average price (quote currency unless viqc set in oflags).
    * `"stopprice"` - stop price (quote currency, for trailing stops).
    * `"limitprice"` - triggered limit price (quote currency, when limit based order type triggered).
    * `"misc"` - comma delimited list of miscellaneous info:
      * `"stopped"` - triggered by stop price.
      * `"touched"` - triggered by touch price.
      * `"liquidated"` - liquidation.
      * `"partial"` - partial fill.
    * `"oflags"` - comma delimited list of order flags:
      * `"viqc"` - volume in quote currency.
      * `"fcib"` - prefer fee in base currency (default if selling).
      * `"fciq"` - prefer fee in quote currency (default if buying).
      * `"nompp"` - no market price protection.
    * `"trades"` - array of trade ids related to order (if trades info requested and data available).

  Note: Unless otherwise stated, costs, fees, prices, and volumes are in the asset pair's
  scale, not the currency's scale. For example, if the asset pair uses a lot size that has a
  scale of 8, the volume will use a scale of 8, even if the currency it represents only has a
  scale of 2. Similarly, if the asset pair's pricing scale is 5, the scale will remain as 5,
  even if the underlying currency has a scale of 8.

  ## Example response:

      {:ok,
        %{
          "open" => %{
            "OVAQ4T-WFN4B-J246BW" => %{
              "cost" => "0.00000000",
              "descr" => %{
                "close" => "",
                "leverage" => "none",
                "order" => "sell 100.00000000 XRPEUR @ limit 1.55000",
                "ordertype" => "limit",
                "pair" => "XRPEUR",
                "price" => "1.55000",
                "price2" => "0",
                "type" => "sell"
              },
              "expiretm" => 0,
              "fee" => "0.00000000",
              "limitprice" => "0.00000000",
              "misc" => "",
              "oflags" => "fciq",
              "opentm" => 1516957593.9522,
              "price" => "0.00000000",
              "refid" => nil,
              "starttm" => 0,
              "status" => "open",
              "stopprice" => "0.00000000",
              "userref" => 0,
              "vol" => "100.00000000",
              "vol_exec" => "0.00000000"
            }
          }
        }}

  """
  @spec open_orders(Client.t(), keyword) :: Krakex.API.response()
  def open_orders(client \\ @api.private_client(), opts \\ [])

  def open_orders(%Client{} = client, opts) when is_list(opts) do
    @api.private_request(client, "OpenOrders", opts)
  end

  def open_orders(opts, []) do
    @api.private_request(@api.private_client(), "OpenOrders", opts)
  end

  @doc """
  Get closed orders.

  Takes the following keyword options:

    * `:trades` - whether or not to include trades in output. `false` (default)
    * `:userref` - restrict results to given user reference id.
    * `:start` - starting unix timestamp or order tx id of results (exclusive).
    * `:end` - ending unix timestamp or order tx id of results (inclusive).
    * `:ofs` - result offset.
    * `:closetime` - which time to use.
      * `"open"`
      * `"close"`
      * `"both"` - (default).

  Returns a map with the key `"closed"` and a map of closed orders as the value. Additionally, the
  map may contain:

    * `"count"` - amount of available order info matching criteria.

  The map of closed orders has the txid as the key and the value is a map with the same fields as
  in open orders (see `open_orders/2`) but can contain the additional fields:

    * `"closetm"` - unix timestamp of when order was closed.
    * `"reason"` - additional info on status (if any).

  Note: Times given by order tx ids are more accurate than unix timestamps. If an order tx id is
  given for the time, the order's open time is used.

  ## Example response:

      {:ok,
        %{
          "closed" => %{
            "O5KKP6-NXBOJ-KPXCTA" => %{
              "closetm" => 1516182880.603,
              "cost" => "57.0",
              "descr" => %{
                "close" => "",
                "leverage" => "none",
                "order" => "buy 0.00670000 XBTEUR @ market",
                "ordertype" => "market",
                "pair" => "XBTEUR",
                "price" => "0",
                "price2" => "0",
                "type" => "buy"
              },
              "expiretm" => 0,
              "fee" => "0.00000",
              "limitprice" => "0.00000",
              "misc" => "",
              "oflags" => "fciq",
              "opentm" => 1516182880.5874,
              "price" => "8510.4",
              "reason" => nil,
              "refid" => nil,
              "starttm" => 0,
              "status" => "closed",
              "stopprice" => "0.00000",
              "userref" => 0,
              "vol" => "0.00670000",
              "vol_exec" => "0.00670000"
            }
          }
        }}

  """
  @spec closed_orders(Client.t(), keyword) :: Krakex.API.response()
  def closed_orders(client \\ @api.private_client(), opts \\ [])

  def closed_orders(%Client{} = client, opts) when is_list(opts) do
    @api.private_request(client, "ClosedOrders", opts)
  end

  def closed_orders(opts, []) do
    @api.private_request(@api.private_client(), "ClosedOrders", opts)
  end

  @doc """
  Query orders info.

  Takes a list of (maximum 20) tx_ids to query info about and the following keyword options:

    * `:trades` - whether or not to include trades in output. `false` (default)
    * `:userref` - restrict results to given user reference id.

  Returns a map with the txid as the key and the value is a map with the fields as described in
  `open_orders/2`.

  """
  @spec query_orders(Client.t(), [binary], keyword) :: Krakex.API.response()
  def query_orders(client \\ @api.private_client(), tx_ids, opts \\ [])

  def query_orders(%Client{} = client, tx_ids, opts) when is_list(opts) do
    @api.private_request(client, "QueryOrders", [txid: tx_ids] ++ opts)
  end

  def query_orders(tx_ids, opts, []) do
    @api.private_request(@api.private_client(), "QueryOrders", [txid: tx_ids] ++ opts)
  end

  @doc """
  Get trades history.

  Takes an offset and the following keyword options:

    * `:type` - type of trade:
      * `"all"` - all types. (default)
      * `"any position"` - any position (open or closed).
      * `"closed position"` - positions that have been closed.
      * `"closing position"` - any trade closing all or part of a position.
      * `"no position"` - non-positional trades.
    * `:trades` - whether or not to include trades related to position in output. (default: `false`)
    * `:start` - starting unix timestamp or trade tx id of results. (exclusive)
    * `:end` - ending unix timestamp or trade tx id of results. (inclusive)

  Returns a map with the fields `"trades"` and `"count"`. The map of trades has the txid as the key
  and the value is a map with fields:

    * `"ordertxid"` - order responsible for execution of trade.
    * `"pair"` - asset pair.
    * `"time"` - unix timestamp of trade.
    * `"type"` - type of order (buy/sell).
    * `"ordertype"` - order type.
    * `"price"` - average price order was executed at (quote currency).
    * `"cost"` - total cost of order (quote currency).
    * `"fee"` - total fee (quote currency).
    * `"vol"` - volume (base currency).
    * `"margin"` - initial margin (quote currency).
    * `"misc"` - comma delimited list of miscellaneous info:
      * `"closing"` - trade closes all or part of a position.

  If the trade opened a position, the follow fields are also present in the trade info:

    * `"posstatus"` - position status (open/closed).
    * `"cprice"` - average price of closed portion of position (quote currency).
    * `"ccost"` - total cost of closed portion of position (quote currency).
    * `"cfee"` - total fee of closed portion of position (quote currency).
    * `"cvol"` - total fee of closed portion of position (quote currency).
    * `"cmargin"` - total margin freed in closed portion of position (quote currency).
    * `"net"` - net profit/loss of closed portion of position (quote currency, quote currency scale).
    * `"trades"` - list of closing trades for position (if available).

  Note:
    * Unless otherwise stated, costs, fees, prices, and volumes are in the asset pair's scale, not
      the currency's scale.
    * Times given by trade tx ids are more accurate than unix timestamps.

  ## Example response:

      {:ok,
        %{
          "count" => 82,
          "trades" => %{
            "TECAE6-7ZWNZ-WICHNR" => %{
              "cost" => "5.11000",
              "fee" => "0.00818",
              "margin" => "0.00000",
              "misc" => "",
              "ordertxid" => "OAOO5O-RAUU2-BCKZIH",
              "ordertype" => "limit",
              "pair" => "XXBTZEUR",
              "price" => "365.00000",
              "time" => 1457183489.6049,
              "type" => "buy",
              "vol" => "0.01400000"
            }
          }
        }}

  """
  @spec trades_history(Client.t(), integer, keyword) :: Krakex.API.response()
  def trades_history(client \\ @api.private_client(), offset, opts \\ [])

  def trades_history(%Client{} = client, offset, opts) do
    @api.private_request(client, "TradesHistory", [ofs: offset] ++ opts)
  end

  def trades_history(offset, opts, []) do
    @api.private_request(@api.private_client(), "TradesHistory", [ofs: offset] ++ opts)
  end

  @doc """
  Query trades info.

  Takes a list of (maximum 20) tx_ids and the following keyword options:

    * `:trades` - whether or not to include trades related to position in output. (default: `false`)

  Returns a map with the same fields as described in `trades_history/2`.
  """
  @spec query_trades(Client.t(), [binary], keyword) :: Krakex.API.response()
  def query_trades(client \\ @api.private_client(), tx_ids, opts \\ [])

  def query_trades(%Client{} = client, tx_ids, opts) when is_list(opts) do
    @api.private_request(client, "QueryTrades", [txid: tx_ids] ++ opts)
  end

  def query_trades(tx_ids, opts, []) do
    @api.private_request(@api.private_client(), "QueryTrades", [txid: tx_ids] ++ opts)
  end

  @doc """
  Get open positions.

  Takes a list of tx_ids to restrict output to and the following keyword options:

    * `:docalcs` - whether or not to include profit/loss calculations. (default: `false`)

  Returns a map with the txid as the key and the value is a map with fields:

    * `"ordertxid"` - order responsible for execution of trade.
    * `"pair"` - asset pair.
    * `"time"` - unix timestamp of trade.
    * `"type"` - type of order used to open position (buy/sell).
    * `"ordertype"` - order type used to open position.
    * `"cost"` - opening cost of position (quote currency unless viqc set in `"oflags"`).
    * `"fee"` - opening fee of position (quote currency).
    * `"vol"` - position volume (base currency unless viqc set in `"oflags"`).
    * `"vol_closed"` - position volume closed (base currency unless viqc set in `"oflags"`).
    * `"margin"` - initial margin (quote currency).
    * `"value"` - current value of remaining position (if docalcs requested.  quote currency).
    * `"net"` - unrealized profit/loss of remaining position (if docalcs requested.  quote currency,
      quote currency scale).
    * `"misc"` - comma delimited list of miscellaneous info.
    * `"oflags"` - comma delimited list of order flags:
      * `"viqc"` - volume in quote currency.

  Note: Unless otherwise stated, costs, fees, prices, and volumes are in the asset pair's scale,
  not the currency's scale.
  """
  @spec open_positions(Client.t(), [binary], keyword) :: Krakex.API.response()
  def open_positions(client \\ @api.private_client(), tx_ids, opts \\ [])

  def open_positions(%Client{} = client, tx_ids, opts) when is_list(opts) do
    @api.private_request(client, "OpenPositions", [txid: tx_ids] ++ opts)
  end

  def open_positions(tx_ids, opts, []) do
    @api.private_request(@api.private_client(), "OpenPositions", [txid: tx_ids] ++ opts)
  end

  @doc """
  Get ledgers info.

  Takes an offset and the following keyword options:

    * `:aclass` - asset class. `"currency"` (default)
    * `:asset` - list of assets to restrict output to. `"currency"` (default)
    * `:type` - type of ledger to retrieve:
      * `"all"` - default.
      * `"deposit"`
      * `"withdrawal"`
      * `"trade"`
      * `"margin"`
    * `:start` - starting unix timestamp or ledger id of results. (exclusive)
    * `:end` - ending unix timestamp or ledger id of results. (inclusive)

  Returns a map with the ledger id as the key and the value is a map with fields:

    * `"refid"` - reference id.
    * `"time"` - unix timestamp of ledger.
    * `"type"` - type of ledger entry.
    * `"aclass"` - asset class.
    * `"asset"` - asset.
    * `"amount"` - transaction amount.
    * `"fee"` - transaction fee.
    * `"balance"` - resulting balance.

  Note: Times given by ledger ids are more accurate than unix timestamps.
  """
  @spec ledgers(Client.t(), integer, keyword) :: Krakex.API.response()
  def ledgers(client \\ @api.private_client(), offset, opts \\ [])

  def ledgers(%Client{} = client, offset, opts) do
    @api.private_request(client, "Ledgers", [ofs: offset] ++ opts)
  end

  def ledgers(offset, opts, []) do
    @api.private_request(@api.private_client(), "Ledgers", [ofs: offset] ++ opts)
  end

  @doc """
  Query ledgers.

  Takes a list of (maximum 20) ledger ids to query info about.

  Returns a map with the ledger id as the key and the value is a map with fields as described
  in `ledgers/3`.
  """
  @spec query_ledgers(Client.t(), [binary]) :: Krakex.API.response()
  def query_ledgers(client \\ @api.private_client(), ledger_ids) do
    @api.private_request(client, "QueryLedgers", id: ledger_ids)
  end

  @doc """
  Get trade volume.

  Takes the following keyword options:

    * `:pair` - list of asset pairs to get fee info on.
    * `:"fee-info"` - whether or not to include fee info in results.

  Returns a map with the following fields:

    * `"currency"` - volume currency.
    * `"volume"` - current discount volume.
    * `"fees"` - map of asset pairs and fee tier info (if requested):
      * `"fee"` - current fee in percent.
      * `"minfee"` - minimum fee for pair (if not fixed fee).
      * `"maxfee"` - maximum fee for pair (if not fixed fee).
      * `"nextfee"` - next tier's fee for pair (if not fixed fee. `nil` if at lowest fee tier).
      * `"nextvolume"` - volume level of next tier (if not fixed fee. `nil` if at lowest fee tier).
      * `"tiervolume"` - volume level of current tier (if not fixed fee. `nil` if at lowest fee tier).
    * `"fees_maker"` - map of asset pairs and maker fee tier info (if requested) for any pairs on maker/taker schedule:
      * `"fee"` - current fee in percent.
      * `"minfee"` - minimum fee for pair (if not fixed fee).
      * `"maxfee"` - maximum fee for pair (if not fixed fee).
      * `"nextfee"` - next tier's fee for pair (if not fixed fee. `nil` if at lowest fee tier).
      * `"nextvolume"` - volume level of next tier (if not fixed fee. `nil` if at lowest fee tier).
      * `"tiervolume"` - volume level of current tier (if not fixed fee. `nil` if at lowest fee tier).

  Note: If an asset pair is on a maker/taker fee schedule, the taker side is given in `"fees"` and
  maker side in `"fees_maker"`. For pairs not on maker/taker, they will only be given in `"fees"`.
  """
  @spec trade_volume(Client.t(), keyword) :: Krakex.API.response()
  def trade_volume(client \\ @api.private_client(), opts \\ [])

  def trade_volume(%Client{} = client, opts) when is_list(opts) do
    @api.private_request(client, "TradeVolume", opts)
  end

  def trade_volume(opts, []) do
    @api.private_request(@api.private_client(), "TradeVolume", opts)
  end

  @doc """
  Add standard order.

  Takes the following arguments:

    * asset pair
    * type - `"buy"` or `"sell"`.
    * ordertype - one of the following:
      * `"market"`
      * `"limit"` - (price = limit price).
      * `"stop-loss"` - (price = stop loss price).
      * `"take-profit"` - (price = take profit price).
      * `"stop-loss-profit"` - (price = stop loss price, price2 = take profit price).
      * `"stop-loss-profit-limit"` - (price = stop loss price, price2 = take profit price).
      * `"stop-loss-limit"` - (price = stop loss trigger price, price2 = triggered limit price).
      * `"take-profit-limit"` - (price = take profit trigger price, price2 = triggered limit price).
      * `"trailing-stop"` - (price = trailing stop offset).
      * `"trailing-stop-limit"` - (price = trailing stop offset, price2 = triggered limit offset).
      * `"stop-loss-and-limit"` - (price = stop loss price, price2 = limit price).
      * `"settle-position"`
    * volume - order volume in lots.

  and the following keyword options:

    * `:price` - price (dependent upon ordertype).
    * `:price2` - secondary price (dependent upon ordertype).
    * `:leverage` - amount of leverage desired (default = none).
    * `:oflags` - list of order flags:
      * `:viqc` - volume in quote currency (not available for leveraged orders).
      * `:fcib` - prefer fee in base currency.
      * `:fciq` - prefer fee in quote currency.
      * `:nompp` - no market price protection.
      * `:post` - post only order (available when ordertype = limit).
    * `:starttm` - scheduled start time:
      * `0` - now (default).
      * `+<n>` - schedule start time <n> seconds from now.
      * `<n>` - unix timestamp of start time.
    * `:expiretm` - expiration time:
      * `0` - no expiration (default).
      * `+<n>` - expire <n> seconds from now.
      * `<n>` - unix timestamp of expiration time.
    * `:userref` - user reference id.  32-bit signed number.
    * `:validate` - validate inputs only (does not submit order).

  Returns a map with the following fields:

    * `"descr"` - order description info.
      * `"order"` - order description.
      * `"close"` - onditional close order description (if conditional close set).
    * `"txid"` - array of transaction ids for order (if order was added successfully).

  Note:
    * See `asset_pairs/2` for specifications on asset pair prices, lots, and leverage.
    * Prices can be preceded by `+`, `-`, or `#` to signify the price as a relative amount (with
      the exception of trailing stops, which are always relative). `+` adds the amount to the
      current offered price. `-` subtracts the amount from the current offered price. `#` will
      either add or subtract the amount to the current offered price, depending on the type and
      order type used. Relative prices can be suffixed with a `%` to signify the relative amount
      as a percentage of the offered price.
    * For orders using leverage, 0 can be used for the volume to auto-fill the volume needed to
      close out your position.
    * If you receive the error `"EOrder:Trading agreement required"`, refer to your API key
      management page for further details.

  ## Example response:

      {:ok,
        %{
          "descr" => %{"order" => "sell 100.00000000 XRPEUR @ limit 1.50000"},
          "txid" => ["OL63HZ-UFU23-CKEBRA"]
        }}

  """
  @spec add_order(Client.t(), binary, binary, binary, number, keyword) :: Krakex.API.response()
  def add_order(client \\ @api.private_client(), pair, type, order_type, volume, opts \\ [])

  def add_order(%Client{} = client, pair, type, order_type, volume, opts) when is_list(opts) do
    opts = [pair: pair, type: type, ordertype: order_type, volume: volume] ++ opts
    @api.private_request(client, "AddOrder", opts)
  end

  def add_order(pair, type, order_type, volume, opts, []) do
    opts = [pair: pair, type: type, ordertype: order_type, volume: volume] ++ opts
    @api.private_request(@api.private_client(), "AddOrder", opts)
  end

  @doc """
  Cancel open order.

  Takes a tx_id for the order to cancel.

  Returns a map with the following fields:

    * `"count"` - number of orders canceled.
    * `"pending"` - if set, order(s) is/are pending cancellation.

  Note: tx_id may be a user reference id.

  ## Example response:

      {:ok, %{"count" => 1}}

  """
  @spec cancel_order(Client.t(), binary) :: Krakex.API.response()
  def cancel_order(client \\ @api.private_client(), tx_id) do
    @api.private_request(client, "CancelOrder", txid: tx_id)
  end

  @doc """
  Get deposit methods.

  Takes an asset and the following keyword options:

    * `:aclass` - asset class. `"currency"` (default)

  Returns a list of maps with the following fields:

    * `"method"` - name of deposit method.
    * `"limit"` - maximum net amount that can be deposited right now, or `false` if no limit.
    * `"fee"` - amount of fees that will be paid.
    * `"address-setup-fee"` - whether or not method has an address setup fee (optional).

  ## Example response:

      {:ok, [%{"fee" => "5.00", "limit" => "25000.00", "method" => "SynapsePay (US Wire)"}]}

  """
  @spec deposit_methods(Client.t(), binary, keyword) :: Krakex.API.response()
  def deposit_methods(client \\ @api.private_client(), asset, opts \\ [])

  def deposit_methods(%Client{} = client, asset, opts) when is_list(opts) do
    @api.private_request(client, "DepositMethods", [asset: asset] ++ opts)
  end

  def deposit_methods(asset, opts, []) do
    @api.private_request(@api.private_client(), "DepositMethods", [asset: asset] ++ opts)
  end

  @doc """
  Get withdrawal information.

  Takes an asset, the withdrawal key name as set up in your account, an amount to withdraw and the
  following keyword options:

    * `:aclass` - asset class. `"currency"` (default)

  Returns a map with the following fields:

    * `"method"` - name of the withdrawal method that will be used.
    * `"limit"` - maximum net amount that can be withdrawn right now.
    * `"fee"` - amount of fees that will be paid.

  ## Example response:

      {:ok,
        %{
          "amount" => "0.10670000",
          "fee" => "0.00100000",
          "limit" => "0.10770000",
          "method" => "Bitcoin"
        }}

  """
  @spec withdraw_info(Client.t(), binary, binary, binary, keyword) :: Krakex.API.response()
  def withdraw_info(client \\ @api.private_client(), asset, key, amount, opts \\ [])

  def withdraw_info(%Client{} = client, asset, key, amount, opts) when is_list(opts) do
    opts = [asset: asset, key: key, amount: amount] ++ opts
    @api.private_request(client, "WithdrawInfo", opts)
  end

  def withdraw_info(asset, key, amount, opts, []) do
    opts = [asset: asset, key: key, amount: amount] ++ opts
    @api.private_request(@api.private_client(), "WithdrawInfo", opts)
  end
end
