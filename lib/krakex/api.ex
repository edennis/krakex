defmodule Krakex.API do
  alias Krakex.Client

  @public_path "/0/public/"
  @private_path "/0/private/"

  def public_request(%Client{http_client: http_client} = client, resource, opts \\ []) do
    url = client.endpoint <> public_path(resource)

    form_data = process_params(opts)

    case http_client.post(url, form_data, []) do
      {:ok, response} ->
        handle_response(response)

      {:error, reason} ->
        {:error, reason}
    end
  end

  defmodule MissingCredentialsError do
    defexception [:message]
  end

  def private_request(client, resource, opts \\ [])

  def private_request(%Client{key: key, secret: secret} = client, resource, opts)
      when is_binary(key) and is_binary(secret) do
    path = private_path(resource)
    nonce = nonce()

    form_data = opts |> Keyword.put(:nonce, nonce) |> process_params()

    headers = [
      {"Api-Key", key},
      {"Api-Sign", signature(path, nonce, form_data, secret)}
    ]

    case client.http_client.post(client.endpoint <> path, form_data, headers) do
      {:ok, response} ->
        handle_response(response)

      {:error, reason} ->
        {:error, reason}
    end
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

  defp handle_response(%{"error" => [], "result" => result}) do
    {:ok, result}
  end

  defp handle_response(%{"error" => errors}) do
    # TODO: check if more than one error can occur
    {:error, hd(errors)}
  end

  defp process_params(params) do
    Enum.map(params, fn {k, v} ->
      case v do
        [] ->
          nil

        v when is_list(v) ->
          {k, Enum.join(v, ",")}

        _ ->
          {k, v}
      end
    end)
    |> Enum.reject(&is_nil/1)
  end
end
