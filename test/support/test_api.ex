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

  def private_request(client, resource, params \\ [])

  def private_request(@private_client, "ClosedOrders", []), do: :closed_orders_0
  def private_request(@custom_client, "ClosedOrders", []), do: :closed_orders_1_client
  def private_request(@private_client, "ClosedOrders", trades: true), do: :closed_orders_1_opts
  def private_request(@custom_client, "ClosedOrders", ofs: 50), do: :closed_orders_2
end
