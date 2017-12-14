defmodule Krakex.Private do
  @behaviour Krakex.API

  alias Krakex.{API, Client, HTTPClient}

  @base_path "/0/private/"

  defmodule MissingCredentialsError do
    defexception [:message]
  end

  def request(client, resource, opts \\ [])

  def request(%Client{key: key, secret: secret} = client, resource, opts)
      when is_binary(key) and is_binary(secret) do
    path = path(resource)
    nonce = nonce()

    form_data = opts |> Keyword.put(:nonce, nonce) |> API.process_params()

    headers = [
      {"Api-Key", key},
      {"Api-Sign", signature(path, nonce, form_data, secret)}
    ]

    case HTTPClient.post(client.endpoint <> path, form_data, headers) do
      {:ok, response} ->
        API.handle_response(response)

      {:error, reason} ->
        {:error, reason}
    end
  end

  def request(%Client{}, _, _) do
    raise MissingCredentialsError, message: "the client is missing values for :key and/or :secret"
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
