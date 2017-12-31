defmodule Krakex.APITest do
  use ExUnit.Case

  alias Krakex.Client
  alias Krakex.API
  alias Krakex.API.MissingCredentialsError

  describe "private_request/3" do
    test "raise on missing credentials" do
      assert_raise MissingCredentialsError, ~r/missing values/, fn ->
        API.private_request(%Client{}, "/foo", [])
      end
    end
  end
end
