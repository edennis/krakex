defmodule KrakexTest do
  use ExUnit.Case

  alias Krakex.TestAPI

  describe "public market data" do
    test "server_time/0" do
      assert Krakex.server_time() == {:ok, :server_time_0}
    end

    test "server_time/1" do
      assert client() |> Krakex.server_time() == {:ok, :server_time_1}
    end

    test "assets/0" do
      assert Krakex.assets() == {:ok, :assets_0}
    end

    test "assets/1 client" do
      assert client() |> Krakex.assets() == {:ok, :assets_1_client}
    end

    test "assets/1 opts" do
      assert Krakex.assets(asset: ["BTC"]) == {:ok, :assets_1_opts}
    end

    test "assets/2" do
      assert client() |> Krakex.assets(asset: ["BTC"]) == {:ok, :assets_2}
    end

    test "asset_pairs/0" do
      assert Krakex.asset_pairs() == {:ok, :asset_pairs_0}
    end

    test "asset_pairs/1 client" do
      assert client() |> Krakex.asset_pairs() == {:ok, :asset_pairs_1_client}
    end

    test "asset_pairs/1 opts" do
      assert Krakex.asset_pairs(pair: ["BTCEUR"]) == {:ok, :asset_pairs_1_opts}
    end

    test "asset_pairs/2" do
      assert client() |> Krakex.asset_pairs(pair: ["BTCEUR"]) == {:ok, :asset_pairs_2}
    end

    test "ticker/1" do
      assert Krakex.ticker(["BTC"]) == {:ok, :ticker_1}
    end

    test "ticker/2" do
      assert client() |> Krakex.ticker(["BTC"]) == {:ok, :ticker_2}
    end

    test "ohlc/1" do
      assert Krakex.ohlc("BTCEUR") == {:ok, :ohlc_1}
    end

    test "ohlc/2 client" do
      assert client() |> Krakex.ohlc("BTCEUR") == {:ok, :ohlc_2_client}
    end

    test "ohlc/2 opts" do
      assert Krakex.ohlc("BTCEUR", interval: 5) == {:ok, :ohlc_2_opts}
    end

    test "ohlc/3" do
      assert client() |> Krakex.ohlc("BTCEUR", interval: 5) == {:ok, :ohlc_3}
    end

    test "depth/1" do
      assert Krakex.depth("BTCEUR") == {:ok, :depth_1}
    end

    test "depth/2 client" do
      assert client() |> Krakex.depth("BTCEUR") == {:ok, :depth_2_client}
    end

    test "depth/2 opts" do
      assert Krakex.depth("BTCEUR", count: 5) == {:ok, :depth_2_opts}
    end

    test "depth/3" do
      assert client() |> Krakex.depth("BTCEUR", count: 5) == {:ok, :depth_3}
    end

    test "trades/1" do
      assert Krakex.trades("BTCEUR") == {:ok, :trades_1}
    end

    test "trades/2 client" do
      assert client() |> Krakex.trades("BTCEUR") == {:ok, :trades_2_client}
    end

    test "trades/2 opts" do
      assert Krakex.trades("BTCEUR", since: 1_514_828_346) == {:ok, :trades_2_opts}
    end

    test "trades/3" do
      assert client() |> Krakex.trades("BTCEUR", since: 1_514_828_346) == {:ok, :trades_3}
    end

    test "spread/1" do
      assert Krakex.spread("BTCEUR") == {:ok, :spread_1}
    end

    test "spread/2 client" do
      assert client() |> Krakex.spread("BTCEUR") == {:ok, :spread_2_client}
    end

    test "spread/2 opts" do
      assert Krakex.spread("BTCEUR", since: 1_514_828_381) == {:ok, :spread_2_opts}
    end

    test "spread/3" do
      assert client() |> Krakex.spread("BTCEUR", since: 1_514_828_381) == {:ok, :spread_3}
    end
  end

  describe "private user data" do
    test "balance/0" do
      assert Krakex.balance() == {:ok, :balance_0}
    end

    test "balance/1" do
      assert client() |> Krakex.balance() == {:ok, :balance_1}
    end

    test "trade_balance/0" do
      assert Krakex.trade_balance() == {:ok, :trade_balance_0}
    end

    test "trade_balance/1 client" do
      assert client() |> Krakex.trade_balance() == {:ok, :trade_balance_1_client}
    end

    test "trade_balance/1 opts" do
      assert Krakex.trade_balance(asset: "ZEUR") == {:ok, :trade_balance_1_opts}
    end

    test "trade_balance/2" do
      assert client() |> Krakex.trade_balance(asset: "ZEUR") == {:ok, :trade_balance_2}
    end

    test "open_orders/0" do
      assert Krakex.open_orders() == {:ok, :open_orders_0}
    end

    test "open_orders/1 client" do
      assert client() |> Krakex.open_orders() == {:ok, :open_orders_1_client}
    end

    test "open_orders/1 opts" do
      assert Krakex.open_orders(trades: true) == {:ok, :open_orders_1_opts}
    end

    test "open_orders/2" do
      assert client() |> Krakex.open_orders(trades: true) == {:ok, :open_orders_2}
    end

    test "closed_orders/0" do
      assert Krakex.closed_orders() == {:ok, :closed_orders_0}
    end

    test "closed_orders/1 client" do
      assert client() |> Krakex.closed_orders() == {:ok, :closed_orders_1_client}
    end

    test "closed_orders/1 opts" do
      assert Krakex.closed_orders(trades: true) == {:ok, :closed_orders_1_opts}
    end

    test "closed_orders/2" do
      assert client() |> Krakex.closed_orders(ofs: 50) == {:ok, :closed_orders_2}
    end

    test "query_orders/1" do
      assert Krakex.query_orders(["OQFZXP-DJRW3-LDF7J5"]) == {:ok, :query_orders_1}
    end

    test "query_orders/2 client" do
      assert client() |> Krakex.query_orders(["OQFZXP-DJRW3-LDF7J5"]) ==
               {:ok, :query_orders_2_client}
    end

    test "query_orders/2 opts" do
      assert Krakex.query_orders(["OQFZXP-DJRW3-LDF7J5"], trades: true) ==
               {:ok, :query_orders_2_opts}
    end

    test "query_orders/3" do
      assert client() |> Krakex.query_orders(["OQFZXP-DJRW3-LDF7J5"], trades: true) ==
               {:ok, :query_orders_3}
    end

    test "trades_history/1" do
      assert Krakex.trades_history(10) == {:ok, :trades_history_1}
    end

    test "trades_history/2 client" do
      assert client() |> Krakex.trades_history(10) == {:ok, :trades_history_2_client}
    end

    test "trades_history/2 opts" do
      assert Krakex.trades_history(10, trades: true) == {:ok, :trades_history_2_opts}
    end

    test "trades_history/3" do
      assert client() |> Krakex.trades_history(10, trades: true) == {:ok, :trades_history_3}
    end

    test "query_trades/1" do
      assert Krakex.query_trades(["OQFZXP-DJRW3-LDF7J5"]) == {:ok, :query_trades_1}
    end

    test "query_trades/2 client" do
      assert client() |> Krakex.query_trades(["OQFZXP-DJRW3-LDF7J5"]) ==
               {:ok, :query_trades_2_client}
    end

    test "query_trades/2 opts" do
      assert Krakex.query_trades(["OQFZXP-DJRW3-LDF7J5"], trades: true) ==
               {:ok, :query_trades_2_opts}
    end

    test "query_trades/3" do
      assert client() |> Krakex.query_trades(["OQFZXP-DJRW3-LDF7J5"], trades: true) ==
               {:ok, :query_trades_3}
    end

    test "open_positions/1" do
      assert Krakex.open_positions(["OQFZXP-DJRW3-LDF7J5"]) == {:ok, :open_positions_1}
    end

    test "open_positions/2 client" do
      assert client() |> Krakex.open_positions(["OQFZXP-DJRW3-LDF7J5"]) ==
               {:ok, :open_positions_2_client}
    end

    test "open_positions/2 opts" do
      assert Krakex.open_positions(["OQFZXP-DJRW3-LDF7J5"], docalcs: true) ==
               {:ok, :open_positions_2_opts}
    end

    test "open_positions/3" do
      assert client() |> Krakex.open_positions(["OQFZXP-DJRW3-LDF7J5"], docalcs: true) ==
               {:ok, :open_positions_3}
    end

    test "ledgers/1" do
      assert Krakex.ledgers(10) == {:ok, :ledgers_1}
    end

    test "ledgers/2 client" do
      assert client() |> Krakex.ledgers(10) == {:ok, :ledgers_2_client}
    end

    test "ledgers/2 opts" do
      assert Krakex.ledgers(10, type: "trade") == {:ok, :ledgers_2_opts}
    end

    test "ledgers/3" do
      assert client() |> Krakex.ledgers(10, type: "trade") == {:ok, :ledgers_3}
    end

    test "query_ledgers/1" do
      assert Krakex.query_ledgers(["LTD2YN-UUDTH-C5NPDX"]) == {:ok, :query_ledgers_1}
    end

    test "query_ledgers/2" do
      assert client() |> Krakex.query_ledgers(["LTD2YN-UUDTH-C5NPDX"]) == {:ok, :query_ledgers_2}
    end

    test "trade_volume/1 client" do
      assert client() |> Krakex.trade_volume(pair: ["BTCEUR"]) == {:ok, :trade_volume_1_client}
    end

    test "trade_volume/1 opts" do
      assert Krakex.trade_volume("fee-info": true) == {:ok, :trade_volume_1_opts}
    end
  end

  describe "private user trading" do
    test "add_order/4" do
      assert Krakex.add_order("BTCEUR", "buy", "market", 0.2) == {:ok, :add_order_4}
    end

    test "add_order/5 client" do
      assert client() |> Krakex.add_order("BTCEUR", "sell", "market", 0.1) ==
               {:ok, :add_order_5_client}
    end

    test "add_order/5 opts" do
      assert Krakex.add_order("BTCEUR", "sell", "limit", 0.5, price: 12900) ==
               {:ok, :add_order_5_opts}
    end

    test "add_order/6" do
      assert client() |> Krakex.add_order("BTCEUR", "buy", "limit", 0.25, price: 11500) ==
               {:ok, :add_order_6}
    end

    test "cancel_order/1" do
      assert Krakex.cancel_order("O2JG54-WQQL7-PUNFUF") == {:ok, :cancel_order_1}
    end

    test "cancel_order/2" do
      assert client() |> Krakex.cancel_order("O2JG54-WQQL7-PUNFUF") == {:ok, :cancel_order_2}
    end
  end

  describe "private user funding" do
    test "deposit_methods/1" do
      assert Krakex.deposit_methods("EUR") == {:ok, :deposit_methods_1}
    end

    test "deposit_methods/2 client" do
      assert client() |> Krakex.deposit_methods("EUR") == {:ok, :deposit_methods_2_client}
    end

    test "deposit_methods/2 opts" do
      assert Krakex.deposit_methods("EUR", aclass: "currency") == {:ok, :deposit_methods_2_opts}
    end

    test "deposit_methods/3" do
      assert client() |> Krakex.deposit_methods("EUR", aclass: "currency") ==
               {:ok, :deposit_methods_3}
    end

    test "deposit_addresses/2" do
      assert Krakex.deposit_addresses("BTC", "Bitcoin") == {:ok, :deposit_addresses_2}
    end

    test "deposit_addresses/3 client" do
      assert client() |> Krakex.deposit_addresses("BTC", "Bitcoin") ==
               {:ok, :deposit_addresses_3_client}
    end

    test "deposit_addresses/3 opts" do
      assert Krakex.deposit_addresses("BTC", "Bitcoin", new: true) ==
               {:ok, :deposit_addresses_3_opts}
    end

    test "deposit_addresses/4" do
      assert client() |> Krakex.deposit_addresses("BTC", "Bitcoin", new: true) ==
               {:ok, :deposit_addresses_4}
    end

    test "deposit_status/2" do
      assert Krakex.deposit_status("BTC", "Bitcoin") == {:ok, :deposit_status_2}
    end

    test "deposit_status/3 client" do
      assert client() |> Krakex.deposit_status("BTC", "Bitcoin") ==
               {:ok, :deposit_status_3_client}
    end

    test "deposit_status/3 opts" do
      assert Krakex.deposit_status("BTC", "Bitcoin", aclass: "currency") ==
               {:ok, :deposit_status_3_opts}
    end

    test "deposit_status/4" do
      assert client() |> Krakex.deposit_status("BTC", "Bitcoin", aclass: "currency") ==
               {:ok, :deposit_status_4}
    end

    test "withdraw_info/3" do
      assert Krakex.withdraw_info("BTC", "my_wallet", "0.5") == {:ok, :withdraw_info_3}
    end

    test "withdraw_info/4 client" do
      assert client() |> Krakex.withdraw_info("BTC", "my_wallet", "0.25") ==
               {:ok, :withdraw_info_4_client}
    end

    test "withdraw_info/4 opts" do
      assert Krakex.withdraw_info("BTC", "my_wallet", "0.75", aclass: "currency") ==
               {:ok, :withdraw_info_4_opts}
    end

    test "withdraw_info/5" do
      assert client() |> Krakex.withdraw_info("BTC", "my_wallet", "0.15", aclass: "currency") ==
               {:ok, :withdraw_info_5}
    end
  end

  defp client, do: TestAPI.custom_client()
end
