defmodule Krakex.APITest do
  use ExUnit.Case

  alias Krakex.Client
  alias Krakex.API
  alias Krakex.API.MissingCredentialsError

  defmodule ClientHelpers do
    def ok, do: {:ok, %{"error" => [], "result" => %{}}}
    def error, do: {:ok, %{"error" => ["boom"]}}
  end

  defmodule PublicClient do
    import ClientHelpers

    @endpoint "https://api.kraken.com/0/public/"

    def get(@endpoint <> "Test", [], []), do: ok()
    def get(@endpoint <> "Param", [foo: "bar"], []), do: ok()
    def get(@endpoint <> "ParamList", [foo: "bar,baz,qux"], []), do: ok()
    def get(@endpoint <> "Error", [], []), do: error()
  end

  defmodule CustomEndpointClient do
    import ClientHelpers

    def get("https//api.test.com/0/public/Test", [], []), do: ok()
    def post("https//api.test.com/0/private/Test", [], []), do: ok()
  end

  describe "public_request/3" do
    setup do
      client = %Client{http_client: PublicClient}
      {:ok, %{client: client}}
    end

    test "result", %{client: client} do
      assert client |> API.public_request("Test", []) == {:ok, %{}}
    end

    test "params", %{client: client} do
      assert client |> API.public_request("Param", foo: "bar") == {:ok, %{}}
    end

    test "params as list", %{client: client} do
      assert client |> API.public_request("ParamList", foo: ["bar", "baz", "qux"]) == {:ok, %{}}
    end

    test "discard params with empty list", %{client: client} do
      assert client |> API.public_request("Test", foo: []) == {:ok, %{}}
    end

    test "discard params with empty values", %{client: client} do
      assert client |> API.public_request("Test", foo: nil, bar: "") == {:ok, %{}}
    end

    test "error", %{client: client} do
      assert client |> API.public_request("Error", []) == {:error, "boom"}
    end

    test "uses endpoint from client" do
      client = %Client{http_client: CustomEndpointClient, endpoint: "https//api.test.com"}
      assert client |> API.public_request("Test", []) == {:ok, %{}}
    end
  end

  defmodule PrivateClient do
    import ClientHelpers

    @endpoint "https://api.kraken.com/0/private/"

    def post(@endpoint <> "Nonce", [nonce: _], _), do: ok()
    def post(@endpoint <> "Key", _, [{"Api-Key", "key"} | _]), do: ok()
    def post(@endpoint <> "Sign", _, [_, {"Api-Sign", _}]), do: ok()
  end

  describe "private_request/3" do
    setup do
      client = %Client{http_client: PrivateClient, key: "key", secret: "secret"}
      {:ok, %{client: client}}
    end

    test "raise on missing credentials" do
      assert_raise MissingCredentialsError, ~r/missing values/, fn ->
        API.private_request(%Client{}, "/foo", [])
      end
    end

    test "adds nonce to params", %{client: client} do
      assert client |> API.private_request("Nonce", []) == {:ok, %{}}
    end

    test "adds api key to headers", %{client: client} do
      assert client |> API.private_request("Key", []) == {:ok, %{}}
    end

    test "adds api signature to headers", %{client: client} do
      assert client |> API.private_request("Sign", []) == {:ok, %{}}
    end

    test "uses endpoint from client", %{client: client} do
      client = %Client{
        client
        | http_client: CustomEndpointClient,
          endpoint: "https//api.test.com"
      }

      assert client |> API.public_request("Test", []) == {:ok, %{}}
    end
  end
end
