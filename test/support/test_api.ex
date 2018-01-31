defmodule Krakex.TestAPI do
  alias Krakex.Client

  @public_client %Client{endpoint: "http://public.test.com"}
  @private_client %Client{endpoint: "http://private.test.com"}
  @custom_client %Client{endpoint: "http://custom.test.com"}

  def custom_client, do: @custom_client
  def public_client, do: @public_client
  def private_client, do: @private_client

  def public_request(client, resource, params \\ [])

  def public_request(@public_client, "Time", []), do: {:ok, :server_time_0}
  def public_request(@custom_client, "Time", []), do: {:ok, :server_time_1}
  def public_request(@public_client, "Assets", []), do: {:ok, :assets_0}
  def public_request(@custom_client, "Assets", []), do: {:ok, :assets_1_client}
  def public_request(@public_client, "Assets", asset: ["BTC"]), do: {:ok, :assets_1_opts}
  def public_request(@custom_client, "Assets", asset: ["BTC"]), do: {:ok, :assets_2}
  def public_request(@public_client, "AssetPairs", []), do: {:ok, :asset_pairs_0}
  def public_request(@custom_client, "AssetPairs", []), do: {:ok, :asset_pairs_1_client}

  def public_request(@public_client, "AssetPairs", pair: ["BTCEUR"]),
    do: {:ok, :asset_pairs_1_opts}

  def public_request(@custom_client, "AssetPairs", pair: ["BTCEUR"]), do: {:ok, :asset_pairs_2}
  def public_request(@public_client, "Ticker", pair: ["BTC"]), do: {:ok, :ticker_1}
  def public_request(@custom_client, "Ticker", pair: ["BTC"]), do: {:ok, :ticker_2}
  def public_request(@public_client, "OHLC", pair: "BTCEUR"), do: {:ok, :ohlc_1}
  def public_request(@custom_client, "OHLC", pair: "BTCEUR"), do: {:ok, :ohlc_2_client}
  def public_request(@public_client, "OHLC", pair: "BTCEUR", interval: 5), do: {:ok, :ohlc_2_opts}
  def public_request(@custom_client, "OHLC", pair: "BTCEUR", interval: 5), do: {:ok, :ohlc_3}
  def public_request(@public_client, "Depth", pair: "BTCEUR"), do: {:ok, :depth_1}
  def public_request(@custom_client, "Depth", pair: "BTCEUR"), do: {:ok, :depth_2_client}
  def public_request(@public_client, "Depth", pair: "BTCEUR", count: 5), do: {:ok, :depth_2_opts}
  def public_request(@custom_client, "Depth", pair: "BTCEUR", count: 5), do: {:ok, :depth_3}
  def public_request(@public_client, "Trades", pair: "BTCEUR"), do: {:ok, :trades_1}
  def public_request(@custom_client, "Trades", pair: "BTCEUR"), do: {:ok, :trades_2_client}

  def public_request(@public_client, "Trades", pair: "BTCEUR", since: 1_514_828_346),
    do: {:ok, :trades_2_opts}

  def public_request(@custom_client, "Trades", pair: "BTCEUR", since: 1_514_828_346),
    do: {:ok, :trades_3}

  def public_request(@public_client, "Spread", pair: "BTCEUR"), do: {:ok, :spread_1}
  def public_request(@custom_client, "Spread", pair: "BTCEUR"), do: {:ok, :spread_2_client}

  def public_request(@public_client, "Spread", pair: "BTCEUR", since: 1_514_828_381),
    do: {:ok, :spread_2_opts}

  def public_request(@custom_client, "Spread", pair: "BTCEUR", since: 1_514_828_381),
    do: {:ok, :spread_3}

  def private_request(client, resource, params \\ [])

  def private_request(@private_client, "Balance", []), do: {:ok, :balance_0}
  def private_request(@custom_client, "Balance", []), do: {:ok, :balance_1}
  def private_request(@private_client, "TradeBalance", []), do: {:ok, :trade_balance_0}
  def private_request(@custom_client, "TradeBalance", []), do: {:ok, :trade_balance_1_client}

  def private_request(@private_client, "TradeBalance", asset: "ZEUR"),
    do: {:ok, :trade_balance_1_opts}

  def private_request(@custom_client, "TradeBalance", asset: "ZEUR"), do: {:ok, :trade_balance_2}
  def private_request(@private_client, "ClosedOrders", []), do: {:ok, :closed_orders_0}
  def private_request(@custom_client, "ClosedOrders", []), do: {:ok, :closed_orders_1_client}

  def private_request(@private_client, "ClosedOrders", trades: true),
    do: {:ok, :closed_orders_1_opts}

  def private_request(@custom_client, "ClosedOrders", ofs: 50), do: {:ok, :closed_orders_2}
  def private_request(@private_client, "OpenOrders", []), do: {:ok, :open_orders_0}
  def private_request(@custom_client, "OpenOrders", []), do: {:ok, :open_orders_1_client}
  def private_request(@private_client, "OpenOrders", trades: true), do: {:ok, :open_orders_1_opts}
  def private_request(@custom_client, "OpenOrders", trades: true), do: {:ok, :open_orders_2}

  def private_request(@private_client, "QueryOrders", txid: ["OQFZXP-DJRW3-LDF7J5"]),
    do: {:ok, :query_orders_1}

  def private_request(@custom_client, "QueryOrders", txid: ["OQFZXP-DJRW3-LDF7J5"]),
    do: {:ok, :query_orders_2_client}

  def private_request(@private_client, "QueryOrders", txid: ["OQFZXP-DJRW3-LDF7J5"], trades: true),
    do: {:ok, :query_orders_2_opts}

  def private_request(@custom_client, "QueryOrders", txid: ["OQFZXP-DJRW3-LDF7J5"], trades: true),
    do: {:ok, :query_orders_3}

  def private_request(@private_client, "TradesHistory", ofs: 10), do: {:ok, :trades_history_1}

  def private_request(@custom_client, "TradesHistory", ofs: 10),
    do: {:ok, :trades_history_2_client}

  def private_request(@private_client, "TradesHistory", ofs: 10, trades: true),
    do: {:ok, :trades_history_2_opts}

  def private_request(@custom_client, "TradesHistory", ofs: 10, trades: true),
    do: {:ok, :trades_history_3}

  def private_request(@private_client, "QueryTrades", txid: ["OQFZXP-DJRW3-LDF7J5"]),
    do: {:ok, :query_trades_1}

  def private_request(@custom_client, "QueryTrades", txid: ["OQFZXP-DJRW3-LDF7J5"]),
    do: {:ok, :query_trades_2_client}

  def private_request(@private_client, "QueryTrades", txid: ["OQFZXP-DJRW3-LDF7J5"], trades: true),
    do: {:ok, :query_trades_2_opts}

  def private_request(@custom_client, "QueryTrades", txid: ["OQFZXP-DJRW3-LDF7J5"], trades: true),
    do: {:ok, :query_trades_3}

  def private_request(@private_client, "OpenPositions", txid: ["OQFZXP-DJRW3-LDF7J5"]),
    do: {:ok, :open_positions_1}

  def private_request(@custom_client, "OpenPositions", txid: ["OQFZXP-DJRW3-LDF7J5"]),
    do: {:ok, :open_positions_2_client}

  def private_request(
        @private_client,
        "OpenPositions",
        txid: ["OQFZXP-DJRW3-LDF7J5"],
        docalcs: true
      ),
      do: {:ok, :open_positions_2_opts}

  def private_request(
        @custom_client,
        "OpenPositions",
        txid: ["OQFZXP-DJRW3-LDF7J5"],
        docalcs: true
      ),
      do: {:ok, :open_positions_3}

  def private_request(@private_client, "Ledgers", ofs: 10), do: {:ok, :ledgers_1}

  def private_request(@custom_client, "Ledgers", ofs: 10), do: {:ok, :ledgers_2_client}

  def private_request(@private_client, "Ledgers", ofs: 10, type: "trade"),
    do: {:ok, :ledgers_2_opts}

  def private_request(@custom_client, "Ledgers", ofs: 10, type: "trade"), do: {:ok, :ledgers_3}

  def private_request(@private_client, "QueryLedgers", id: ["LTD2YN-UUDTH-C5NPDX"]),
    do: {:ok, :query_ledgers_1}

  def private_request(@custom_client, "QueryLedgers", id: ["LTD2YN-UUDTH-C5NPDX"]),
    do: {:ok, :query_ledgers_2}

  def private_request(@custom_client, "TradeVolume", pair: ["BTCEUR"]),
    do: {:ok, :trade_volume_1_client}

  def private_request(@private_client, "TradeVolume", "fee-info": true),
    do: {:ok, :trade_volume_1_opts}

  def private_request(
        @private_client,
        "AddOrder",
        pair: "BTCEUR",
        type: "buy",
        ordertype: "market",
        volume: 0.2
      ),
      do: {:ok, :add_order_4}

  def private_request(
        @custom_client,
        "AddOrder",
        pair: "BTCEUR",
        type: "sell",
        ordertype: "market",
        volume: 0.1
      ),
      do: {:ok, :add_order_5_client}

  def private_request(
        @private_client,
        "AddOrder",
        pair: "BTCEUR",
        type: "sell",
        ordertype: "limit",
        volume: 0.5,
        price: 12900
      ),
      do: {:ok, :add_order_5_opts}

  def private_request(
        @custom_client,
        "AddOrder",
        pair: "BTCEUR",
        type: "buy",
        ordertype: "limit",
        volume: 0.25,
        price: 11500
      ),
      do: {:ok, :add_order_6}

  def private_request(@private_client, "CancelOrder", txid: "O2JG54-WQQL7-PUNFUF"),
    do: {:ok, :cancel_order_1}

  def private_request(@custom_client, "CancelOrder", txid: "O2JG54-WQQL7-PUNFUF"),
    do: {:ok, :cancel_order_2}

  def private_request(@private_client, "DepositMethods", asset: "EUR"),
    do: {:ok, :deposit_methods_1}

  def private_request(@custom_client, "DepositMethods", asset: "EUR"),
    do: {:ok, :deposit_methods_2_client}

  def private_request(@private_client, "DepositMethods", asset: "EUR", aclass: "currency"),
    do: {:ok, :deposit_methods_2_opts}

  def private_request(@custom_client, "DepositMethods", asset: "EUR", aclass: "currency"),
    do: {:ok, :deposit_methods_3}

  def private_request(@private_client, "DepositAddresses", asset: "BTC", method: "Bitcoin"),
    do: {:ok, :deposit_addresses_2}

  def private_request(@custom_client, "DepositAddresses", asset: "BTC", method: "Bitcoin"),
    do: {:ok, :deposit_addresses_3_client}

  def private_request(
        @private_client,
        "DepositAddresses",
        asset: "BTC",
        method: "Bitcoin",
        new: true
      ),
      do: {:ok, :deposit_addresses_3_opts}

  def private_request(
        @custom_client,
        "DepositAddresses",
        asset: "BTC",
        method: "Bitcoin",
        new: true
      ),
      do: {:ok, :deposit_addresses_4}

  def private_request(@private_client, "DepositStatus", asset: "BTC", method: "Bitcoin"),
    do: {:ok, :deposit_status_2}

  def private_request(@custom_client, "DepositStatus", asset: "BTC", method: "Bitcoin"),
    do: {:ok, :deposit_status_3_client}

  def private_request(
        @private_client,
        "DepositStatus",
        asset: "BTC",
        method: "Bitcoin",
        aclass: "currency"
      ),
      do: {:ok, :deposit_status_3_opts}

  def private_request(
        @custom_client,
        "DepositStatus",
        asset: "BTC",
        method: "Bitcoin",
        aclass: "currency"
      ),
      do: {:ok, :deposit_status_4}

  def private_request(
        @private_client,
        "WithdrawInfo",
        asset: "BTC",
        key: "my_wallet",
        amount: "0.5"
      ),
      do: {:ok, :withdraw_info_3}

  def private_request(
        @custom_client,
        "WithdrawInfo",
        asset: "BTC",
        key: "my_wallet",
        amount: "0.25"
      ),
      do: {:ok, :withdraw_info_4_client}

  def private_request(
        @private_client,
        "WithdrawInfo",
        asset: "BTC",
        key: "my_wallet",
        amount: "0.75",
        aclass: "currency"
      ),
      do: {:ok, :withdraw_info_4_opts}

  def private_request(
        @custom_client,
        "WithdrawInfo",
        asset: "BTC",
        key: "my_wallet",
        amount: "0.15",
        aclass: "currency"
      ),
      do: {:ok, :withdraw_info_5}
end
