defmodule Krakex.HTTPClientTest do
  use ExUnit.Case

  alias Krakex.HTTPClient, as: Client

  defmodule DummyHTTPClient do
    def post("http://example.com/valid.json", _params, _headers),
      do: {:ok, %{status_code: 200, body: ~s/{"foo":"bar"}/}}

    def post("http://example.com/valid-204.json", _params, _headers),
      do: {:ok, %{status_code: 204, body: ~s/{"foo":"bar"}/}}

    def post("http://example.com/invalid.json", _params, _headers),
      do: {:ok, %{status_code: 200, body: ~s/{"foo":"bar/}}

    def post("http://example.com/invalid.txt", _params, _headers),
      do: {:ok, %{status_code: 200, body: "not json"}}

    def post("http://example.com/notfound.json", _params, _headers),
      do: {:ok, %{status_code: 404, body: "not found"}}
  end

  describe "post/3" do
    test "valid json" do
      assert Client.post("http://example.com/valid.json", [], [], DummyHTTPClient) ==
               {:ok, %{"foo" => "bar"}}
    end

    test "valid json 204" do
      assert Client.post("http://example.com/valid-204.json", [], [], DummyHTTPClient) ==
               {:ok, %{"foo" => "bar"}}
    end

    test "invalid json" do
      assert Client.post("http://example.com/invalid.json", [], [], DummyHTTPClient) ==
               {:error, {:invalid, ~s/{"foo":"bar/}}
    end

    test "invalid content" do
      assert Client.post("http://example.com/invalid.txt", [], [], DummyHTTPClient) ==
               {:error, {:invalid, "not json"}}
    end

    test "404" do
      assert Client.post("http://example.com/notfound.json", [], [], DummyHTTPClient) ==
               {:error, {404, "not found"}}
    end
  end
end
