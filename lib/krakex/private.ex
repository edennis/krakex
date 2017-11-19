defmodule Krakex.Private do
  @behaviour Krakex.API

  alias Krakex.{API, HTTPClient}

  @base_path "/0/private/"

  def request(client, resource, opts \\ []) do
    path = path(resource)
    nonce = nonce()

    form_data = opts |> Keyword.put(:nonce, nonce) |> API.process_params()

    headers = [
      {"Api-Key", client.key},
      {"Api-Sign", signature(path, nonce, form_data, client.secret)}
    ]

    case HTTPClient.post(client.endpoint <> path, form_data, headers) do
      {:ok, response} ->
        API.handle_response(response)

      {:error, reason} ->
        {:error, reason}
    end
  end

  def path(resource) do
    @base_path <> resource
  end

  defp nonce do
    System.system_time() |> to_string()
  end

  defp signature(path, nonce, form_data, secret) do
    params = URI.encode_query(form_data)
    sha_sum = :crypto.hash(:sha256, nonce <> params)
    mac_sum = :crypto.hmac(:sha512, secret, path <> sha_sum)
    Base.encode64(mac_sum)
  end
end
