defmodule Krakex.API do
  alias Krakex.Client

  @public_path "/0/public/"
  @private_path "/0/private/"

  def public_request(%Client{http_client: http_client} = client, resource, params \\ []) do
    url = client.endpoint <> public_path(resource)
    params = process_params(params)
    response = http_client.get(url, params, [])
    handle_http_response(response)
  end

  defmodule MissingCredentialsError do
    defexception [:message]
  end

  def private_request(client, resource, params \\ [])

  def private_request(%Client{key: key, secret: secret} = client, resource, params)
      when is_binary(key) and is_binary(secret) do
    path = private_path(resource)
    nonce = nonce()

    form_data = params |> Keyword.put(:nonce, nonce) |> process_params()

    headers = [
      {"Api-Key", key},
      {"Api-Sign", signature(path, nonce, form_data, secret)}
    ]

    response = client.http_client.post(client.endpoint <> path, form_data, headers)
    handle_http_response(response)
  end

  def private_request(%Client{}, _, _) do
    raise MissingCredentialsError, message: "the client is missing values for :key and/or :secret"
  end

  defp public_path(resource) do
    @public_path <> resource
  end

  defp private_path(resource) do
    @private_path <> resource
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

  defp handle_http_response({:ok, response}), do: handle_api_response(response)
  defp handle_http_response({:error, reason}), do: {:error, reason}

  defp handle_api_response(%{"error" => [], "result" => result}), do: {:ok, result}
  # TODO: check if more than one error can occur
  defp handle_api_response(%{"error" => errors}), do: {:error, hd(errors)}

  defp process_params(params) do
    Enum.map(params, fn {k, v} ->
      case v do
        v when is_list(v) ->
          {k, Enum.join(v, ",")}

        _ ->
          {k, v}
      end
    end)
    |> Enum.reject(&is_empty/1)
  end

  defp is_empty({_, v}) when v in [nil, ""], do: true
  defp is_empty(_), do: false
end
