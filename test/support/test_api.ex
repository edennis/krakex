defmodule Krakex.TestAPI do
  alias Krakex.Client

  @public_client %Client{endpoint: "http://public.test.com"}
  @private_client %Client{endpoint: "http://private.test.com"}
  @custom_client %Client{endpoint: "http://custom.test.com"}

  def custom_client, do: @custom_client
  def public_client, do: @public_client
  def private_client, do: @private_client

  def public_request(client, resource, params \\ [])

  def public_request(@public_client, "Time", []), do: :server_time_0
  def public_request(@custom_client, "Time", []), do: :server_time_1
  def public_request(@public_client, "Assets", []), do: :assets_0
  def public_request(@custom_client, "Assets", []), do: :assets_1_client
  def public_request(@public_client, "Assets", asset: ["BTC"]), do: :assets_1_opts
  def public_request(@custom_client, "Assets", asset: ["BTC"]), do: :assets_2
  def public_request(@public_client, "AssetPairs", []), do: :asset_pairs_0
  def public_request(@custom_client, "AssetPairs", []), do: :asset_pairs_1_client
  def public_request(@public_client, "AssetPairs", pair: ["BTCEUR"]), do: :asset_pairs_1_opts
  def public_request(@custom_client, "AssetPairs", pair: ["BTCEUR"]), do: :asset_pairs_2
  def public_request(@public_client, "Ticker", pair: ["BTC"]), do: :ticker_1
  def public_request(@custom_client, "Ticker", pair: ["BTC"]), do: :ticker_2
  def public_request(@public_client, "OHLC", pair: "BTCEUR"), do: :ohlc_1
  def public_request(@custom_client, "OHLC", pair: "BTCEUR"), do: :ohlc_2_client
  def public_request(@public_client, "OHLC", pair: "BTCEUR", interval: 5), do: :ohlc_2_opts
  def public_request(@custom_client, "OHLC", pair: "BTCEUR", interval: 5), do: :ohlc_3
  def public_request(@public_client, "Depth", pair: "BTCEUR"), do: :depth_1
  def public_request(@custom_client, "Depth", pair: "BTCEUR"), do: :depth_2_client
  def public_request(@public_client, "Depth", pair: "BTCEUR", count: 5), do: :depth_2_opts
  def public_request(@custom_client, "Depth", pair: "BTCEUR", count: 5), do: :depth_3
  def public_request(@public_client, "Trades", pair: "BTCEUR"), do: :trades_1
  def public_request(@custom_client, "Trades", pair: "BTCEUR"), do: :trades_2_client

  def public_request(@public_client, "Trades", pair: "BTCEUR", since: 1_514_828_346),
    do: :trades_2_opts

  def public_request(@custom_client, "Trades", pair: "BTCEUR", since: 1_514_828_346),
    do: :trades_3

  def public_request(@public_client, "Spread", pair: "BTCEUR"), do: :spread_1
  def public_request(@custom_client, "Spread", pair: "BTCEUR"), do: :spread_2_client

  def public_request(@public_client, "Spread", pair: "BTCEUR", since: 1_514_828_381),
    do: :spread_2_opts

  def public_request(@custom_client, "Spread", pair: "BTCEUR", since: 1_514_828_381),
    do: :spread_3

  def private_request(client, resource, params \\ [])

  def private_request(@private_client, "Balance", []), do: :balance_0
  def private_request(@custom_client, "Balance", []), do: :balance_1
  def private_request(@private_client, "TradeBalance", []), do: :trade_balance_0
  def private_request(@custom_client, "TradeBalance", []), do: :trade_balance_1_client
  def private_request(@private_client, "TradeBalance", asset: "ZEUR"), do: :trade_balance_1_opts
  def private_request(@custom_client, "TradeBalance", asset: "ZEUR"), do: :trade_balance_2
  def private_request(@private_client, "ClosedOrders", []), do: :closed_orders_0
  def private_request(@custom_client, "ClosedOrders", []), do: :closed_orders_1_client
  def private_request(@private_client, "ClosedOrders", trades: true), do: :closed_orders_1_opts
  def private_request(@custom_client, "ClosedOrders", ofs: 50), do: :closed_orders_2
  def private_request(@private_client, "OpenOrders", []), do: :open_orders_0
  def private_request(@custom_client, "OpenOrders", []), do: :open_orders_1_client
  def private_request(@private_client, "OpenOrders", trades: true), do: :open_orders_1_opts
  def private_request(@custom_client, "OpenOrders", trades: true), do: :open_orders_2

  def private_request(@private_client, "QueryOrders", txid: ["OQFZXP-DJRW3-LDF7J5"]),
    do: :query_orders_1

  def private_request(@custom_client, "QueryOrders", txid: ["OQFZXP-DJRW3-LDF7J5"]),
    do: :query_orders_2_client

  def private_request(@private_client, "QueryOrders", txid: ["OQFZXP-DJRW3-LDF7J5"], trades: true),
    do: :query_orders_2_opts

  def private_request(@custom_client, "QueryOrders", txid: ["OQFZXP-DJRW3-LDF7J5"], trades: true),
    do: :query_orders_3

  def private_request(@private_client, "TradesHistory", ofs: 10), do: :trades_history_1

  def private_request(@custom_client, "TradesHistory", ofs: 10), do: :trades_history_2_client

  def private_request(@private_client, "TradesHistory", ofs: 10, trades: true),
    do: :trades_history_2_opts

  def private_request(@custom_client, "TradesHistory", ofs: 10, trades: true),
    do: :trades_history_3

  def private_request(@private_client, "QueryTrades", txid: ["OQFZXP-DJRW3-LDF7J5"]),
    do: :query_trades_1

  def private_request(@custom_client, "QueryTrades", txid: ["OQFZXP-DJRW3-LDF7J5"]),
    do: :query_trades_2_client

  def private_request(@private_client, "QueryTrades", txid: ["OQFZXP-DJRW3-LDF7J5"], trades: true),
    do: :query_trades_2_opts

  def private_request(@custom_client, "QueryTrades", txid: ["OQFZXP-DJRW3-LDF7J5"], trades: true),
    do: :query_trades_3

  def private_request(@private_client, "OpenPositions", txid: ["OQFZXP-DJRW3-LDF7J5"]),
    do: :open_positions_1

  def private_request(@custom_client, "OpenPositions", txid: ["OQFZXP-DJRW3-LDF7J5"]),
    do: :open_positions_2_client

  def private_request(
        @private_client,
        "OpenPositions",
        txid: ["OQFZXP-DJRW3-LDF7J5"],
        docalcs: true
      ),
      do: :open_positions_2_opts

  def private_request(
        @custom_client,
        "OpenPositions",
        txid: ["OQFZXP-DJRW3-LDF7J5"],
        docalcs: true
      ),
      do: :open_positions_3

  def private_request(@private_client, "Ledgers", ofs: 10), do: :ledgers_1

  def private_request(@custom_client, "Ledgers", ofs: 10), do: :ledgers_2_client

  def private_request(@private_client, "Ledgers", ofs: 10, type: "trade"), do: :ledgers_2_opts

  def private_request(@custom_client, "Ledgers", ofs: 10, type: "trade"), do: :ledgers_3

  def private_request(@private_client, "QueryLedgers", id: ["LTD2YN-UUDTH-C5NPDX"]),
    do: :query_ledgers_1

  def private_request(@custom_client, "QueryLedgers", id: ["LTD2YN-UUDTH-C5NPDX"]),
    do: :query_ledgers_2

  def private_request(@private_client, "TradeVolume", pair: ["BTCEUR"]), do: :trade_volume_1

  def private_request(@custom_client, "TradeVolume", pair: ["BTCEUR"]), do: :trade_volume_2_client

  def private_request(@private_client, "TradeVolume", pair: ["BTCEUR"], "fee-info": true),
    do: :trade_volume_2_opts

  def private_request(@custom_client, "TradeVolume", pair: ["BTCEUR"], "fee-info": true),
    do: :trade_volume_3
end
