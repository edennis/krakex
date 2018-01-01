defmodule KrakexTest do
  use ExUnit.Case
  doctest Krakex

  alias Krakex.TestAPI

  describe "public market data" do
    test "server_time/0" do
      assert Krakex.server_time() == :server_time_0
    end

    test "server_time/1" do
      assert client() |> Krakex.server_time() == :server_time_1
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
