defmodule KrakexTest do
  use ExUnit.Case
  doctest Krakex

  alias Krakex.{Client, Fixture}

  defmodule TestClient do
    def get("https://api.kraken.com/0/public/Time", _, _), do: {:ok, Fixture.load!("server_time")}
    def get("https://api.kraken.com/0/public/Assets", _, _), do: {:ok, Fixture.load!("assets")}
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
  end

  describe "private user data" do
  end
end
