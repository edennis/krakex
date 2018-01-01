defmodule Krakex.TestAPI do
  alias Krakex.Client

  def public_client, do: Client.new()

  def public_request(client, resource, params \\ [])

  def public_request(_client, _resource, _params) do
  end

  def private_client do
  end

  def private_request(client, resource, params \\ [])

  def private_request(_client, _resource, _params) do
  end
end
