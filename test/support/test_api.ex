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
end
