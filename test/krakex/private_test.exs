defmodule Krakex.PrivateTest do
  use ExUnit.Case

  alias Krakex.Client
  alias Krakex.Private
  alias Krakex.Private.MissingCredentialsError

  describe "request/3" do
    test "raise on missing credentials" do
      assert_raise MissingCredentialsError, ~r/missing values/, fn ->
        Private.request(%Client{}, "/foo", [])
      end
    end
  end
end
