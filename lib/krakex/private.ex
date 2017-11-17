defmodule Krakex.Private do
  @base_path "/0/private/"

  def request(client, resource, opts \\ []) do
    path = path(resource)
    nonce = nonce()

    {params, opts} = Keyword.pop(opts, :params)
    encoded_params = URI.encode_query([nonce: nonce] ++ process_params(params))

    headers = [
      {"Api-Key", client.key},
      {"Api-Sign", signature(path, nonce, encoded_params, client.secret)},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]

    case HTTPoison.post(client.endpoint <> path, encoded_params, headers, opts) do
      {:ok, %{status_code: 200, body: body}} ->
        case Poison.decode(body) do
          {:ok, data} ->
            handle_api_reponse(data)

          {:error, reason} ->
            {:error, reason}
        end

      {:ok, %{body: body}} ->
        case Poison.decode(body) do
          {:ok, data} ->
            handle_api_reponse(data)

          {:error, reason} ->
            {:error, reason}
        end

      {:error, %{reason: reason}} ->
        {:error, reason}
    end
  end

  defp handle_api_reponse(%{"error" => [], "result" => result}) do
    {:ok, result}
  end

  defp handle_api_reponse(%{"error" => errors}) do
    {:error, hd(errors)}
  end

  defp path(resource) do
    @base_path <> resource
  end

  defp process_params(params) when is_list(params) do
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

  defp process_params(_), do: []

  defp nonce do
    System.system_time() |> to_string()
  end

  def signature(path, nonce, params, secret) do
    sha_sum = :crypto.hash(:sha256, nonce <> params)
    mac_sum = :crypto.hmac(:sha512, secret, path <> sha_sum)
    Base.encode64(mac_sum)
  end
end
