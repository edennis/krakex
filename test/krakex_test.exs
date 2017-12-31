defmodule KrakexTest do
  use ExUnit.Case
  doctest Krakex

  alias Krakex.{Client, Fixture}

  defmodule TestClient do
    def get("https://api.kraken.com/0/public/Time", _, _), do: {:ok, Fixture.load!("server_time")}
    def get("https://api.kraken.com/0/public/Assets", _, _), do: {:ok, Fixture.load!("assets")}

    def get("https://api.kraken.com/0/public/AssetPairs", _, _),
      do: {:ok, Fixture.load!("asset_pairs")}
  end

  describe "public market data" do
    setup do
      client = %Client{http_client: TestClient}
      {:ok, %{client: client}}
    end

    test "server_time/1", %{client: client} do
      expected = %{"rfc1123" => "Sat, 16 Dec 17 10:52:38 +0000", "unixtime" => 1_513_421_558}

      assert client |> Krakex.server_time() == {:ok, expected}
    end

    test "assets/1", %{client: client} do
      expected = %{
        "XETH" => %{
          "aclass" => "currency",
          "altname" => "ETH",
          "decimals" => 10,
          "display_decimals" => 5
        },
        "XXBT" => %{
          "aclass" => "currency",
          "altname" => "XBT",
          "decimals" => 10,
          "display_decimals" => 5
        },
        "ZEUR" => %{
          "aclass" => "currency",
          "altname" => "EUR",
          "decimals" => 4,
          "display_decimals" => 2
        },
        "ZUSD" => %{
          "aclass" => "currency",
          "altname" => "USD",
          "decimals" => 4,
          "display_decimals" => 2
        }
      }

      assert client |> Krakex.assets() == {:ok, expected}
    end

    test "asset_pairs/1", %{client: client} do
      expected = %{
        "BCHEUR" => %{
          "aclass_base" => "currency",
          "aclass_quote" => "currency",
          "altname" => "BCHEUR",
          "base" => "BCH",
          "fee_volume_currency" => "ZUSD",
          "fees" => [
            [0, 0.26],
            [50000, 0.24],
            [100_000, 0.22],
            [250_000, 0.2],
            [500_000, 0.18],
            [1_000_000, 0.16],
            [2_500_000, 0.14],
            [5_000_000, 0.12],
            [10_000_000, 0.1]
          ],
          "fees_maker" => [
            [0, 0.16],
            [50000, 0.14],
            [100_000, 0.12],
            [250_000, 0.1],
            [500_000, 0.08],
            [1_000_000, 0.06],
            [2_500_000, 0.04],
            [5_000_000, 0.02],
            [10_000_000, 0]
          ],
          "leverage_buy" => [],
          "leverage_sell" => [],
          "lot" => "unit",
          "lot_decimals" => 8,
          "lot_multiplier" => 1,
          "margin_call" => 80,
          "margin_stop" => 40,
          "pair_decimals" => 1,
          "quote" => "ZEUR"
        }
      }

      assert client |> Krakex.asset_pairs() == {:ok, expected}
    end
  end

  describe "private user data" do
  end
end
