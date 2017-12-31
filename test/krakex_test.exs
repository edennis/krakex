defmodule KrakexTest do
  use ExUnit.Case
  doctest Krakex

  alias Krakex.Fixture

  defmodule TestClient do
    def get("https://api.kraken.com/0/public/Time", _, _), do: {:ok, Fixture.load!("server_time")}
  end

  setup_all do
    client = %Krakex.Client{http_client: TestClient}
    {:ok, %{client: client}}
  end

  describe "server_time/1" do
    test "foo", %{client: client} do
      result = client |> Krakex.server_time()

      assert result ==
               {:ok, %{"rfc1123" => "Sat, 16 Dec 17 10:52:38 +0000", "unixtime" => 1_513_421_558}}
    end
  end
end
