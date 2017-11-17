defmodule Krakex.ClientTest do
  use ExUnit.Case

  alias Krakex.Client

  describe "new/0" do
    test "default endpoint" do
      client = Client.new()
      assert client.endpoint == "https://api.kraken.com"
    end
  end

  describe "new/2" do
    test "valid params" do
      secret = Base.encode64("foo")
      assert %Client{key: "key", secret: "foo"} = Client.new("key", secret)
    end

    test "invalid private key" do
      assert_raise RuntimeError, ~r/private_key is not Base64 encoded/, fn ->
        Client.new("key", "invalid")
      end
    end
  end

  describe "new/3" do
    test "custom endpoint" do
      client = Client.new("key", "", "http://api.test.com")
      assert client.endpoint == "http://api.test.com"
    end
  end
end
