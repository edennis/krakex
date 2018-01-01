defmodule KrakexTest do
  use ExUnit.Case

  alias Krakex.TestAPI

  describe "public market data" do
    test "server_time/0" do
      assert Krakex.server_time() == :server_time_0
    end

    test "server_time/1" do
      assert client() |> Krakex.server_time() == :server_time_1
    end

    test "assets/0" do
      assert Krakex.assets() == :assets_0
    end

    test "assets/1 client" do
      assert client() |> Krakex.assets() == :assets_1_client
    end

    test "assets/1 opts" do
      assert Krakex.assets(asset: ["BTC"]) == :assets_1_opts
    end

    test "assets/2" do
      assert client() |> Krakex.assets(asset: ["BTC"]) == :assets_2
    end

    test "asset_pairs/0" do
      assert Krakex.asset_pairs() == :asset_pairs_0
    end

    test "asset_pairs/1 client" do
      assert client() |> Krakex.asset_pairs() == :asset_pairs_1_client
    end

    test "asset_pairs/1 opts" do
      assert Krakex.asset_pairs(pair: ["BTCEUR"]) == :asset_pairs_1_opts
    end

    test "asset_pairs/2" do
      assert client() |> Krakex.asset_pairs(pair: ["BTCEUR"]) == :asset_pairs_2
    end

    test "ticker/1" do
      assert Krakex.ticker(["BTC"]) == :ticker_1
    end

    test "ticker/2" do
      assert client() |> Krakex.ticker(["BTC"]) == :ticker_2
    end

    test "ohlc/1" do
      assert Krakex.ohlc("BTCEUR") == :ohlc_1
    end

    test "ohlc/2 client" do
      assert client() |> Krakex.ohlc("BTCEUR") == :ohlc_2_client
    end

    test "ohlc/2 opts" do
      assert Krakex.ohlc("BTCEUR", interval: 5) == :ohlc_2_opts
    end

    test "ohlc/3" do
      assert client() |> Krakex.ohlc("BTCEUR", interval: 5) == :ohlc_3
    end

    test "depth/1" do
      assert Krakex.depth("BTCEUR") == :depth_1
    end

    test "depth/2 client" do
      assert client() |> Krakex.depth("BTCEUR") == :depth_2_client
    end

    test "depth/2 opts" do
      assert Krakex.depth("BTCEUR", count: 5) == :depth_2_opts
    end

    test "depth/3" do
      assert client() |> Krakex.depth("BTCEUR", count: 5) == :depth_3
    end

    test "trades/1" do
      assert Krakex.trades("BTCEUR") == :trades_1
    end

    test "trades/2 client" do
      assert client() |> Krakex.trades("BTCEUR") == :trades_2_client
    end

    test "trades/2 opts" do
      assert Krakex.trades("BTCEUR", since: 1_514_828_346) == :trades_2_opts
    end

    test "trades/3" do
      assert client() |> Krakex.trades("BTCEUR", since: 1_514_828_346) == :trades_3
    end

    test "spread/1" do
      assert Krakex.spread("BTCEUR") == :spread_1
    end

    test "spread/2 client" do
      assert client() |> Krakex.spread("BTCEUR") == :spread_2_client
    end

    test "spread/2 opts" do
      assert Krakex.spread("BTCEUR", since: 1_514_828_381) == :spread_2_opts
    end

    test "spread/3" do
      assert client() |> Krakex.spread("BTCEUR", since: 1_514_828_381) == :spread_3
    end
  end

  describe "private user data" do
    test "balance/0" do
      assert Krakex.balance() == :balance_0
    end

    test "balance/1" do
      assert client() |> Krakex.balance() == :balance_1
    end

    test "trade_balance/0" do
      assert Krakex.trade_balance() == :trade_balance_0
    end

    test "trade_balance/1 client" do
      assert client() |> Krakex.trade_balance() == :trade_balance_1_client
    end

    test "trade_balance/1 opts" do
      assert Krakex.trade_balance(asset: "ZEUR") == :trade_balance_1_opts
    end

    test "trade_balance/2" do
      assert client() |> Krakex.trade_balance(asset: "ZEUR") == :trade_balance_2
    end

    test "open_orders/0" do
      assert Krakex.open_orders() == :open_orders_0
    end

    test "open_orders/1 client" do
      assert client() |> Krakex.open_orders() == :open_orders_1_client
    end

    test "open_orders/1 opts" do
      assert Krakex.open_orders(trades: true) == :open_orders_1_opts
    end

    test "open_orders/2" do
      assert client() |> Krakex.open_orders(trades: true) == :open_orders_2
    end

    test "closed_orders/0" do
      assert Krakex.closed_orders() == :closed_orders_0
    end

    test "closed_orders/1 client" do
      assert client() |> Krakex.closed_orders() == :closed_orders_1_client
    end

    test "closed_orders/1 opts" do
      assert Krakex.closed_orders(trades: true) == :closed_orders_1_opts
    end

    test "closed_orders/2" do
      assert client() |> Krakex.closed_orders(ofs: 50) == :closed_orders_2
    end

    test "query_orders/1" do
      assert Krakex.query_orders(["OQFZXP-DJRW3-LDF7J5"]) == :query_orders_1
    end

    test "query_orders/2 client" do
      assert client() |> Krakex.query_orders(["OQFZXP-DJRW3-LDF7J5"]) == :query_orders_2_client
    end

    test "query_orders/2 opts" do
      assert Krakex.query_orders(["OQFZXP-DJRW3-LDF7J5"], trades: true) == :query_orders_2_opts
    end

    test "query_orders/3" do
      assert client() |> Krakex.query_orders(["OQFZXP-DJRW3-LDF7J5"], trades: true) ==
               :query_orders_3
    end
  end

  defp client, do: TestAPI.custom_client()
end
