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
  end

  describe "private user data" do
    test "closed_orders/0" do
      assert Krakex.closed_orders() == :closed_orders_0
    end

    test "closed_orders/1 opts" do
      assert Krakex.closed_orders(trades: true) == :closed_orders_1_opts
    end

    test "closed_orders/1 client" do
      assert client() |> Krakex.closed_orders() == :closed_orders_1_client
    end

    test "closed_orders/2" do
      assert client() |> Krakex.closed_orders(ofs: 50) == :closed_orders_2
    end
  end

  defp client, do: TestAPI.custom_client()
end
