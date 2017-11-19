defmodule Krakex.Private do
  alias Krakex.HTTPClient

  @base_path "/0/private/"

  def request(client, resource, opts \\ []) do
    path = path(resource)
    nonce = nonce()

    form_data = opts |> Keyword.put(:nonce, nonce) |> process_params()

    headers = [
      {"Api-Key", client.key},
      {"Api-Sign", signature(path, nonce, form_data, client.secret)}
    ]

    case HTTPClient.post(client.endpoint <> path, form_data, headers) do
      {:ok, response} ->
        handle_api_response(response)

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp handle_api_response(%{"error" => [], "result" => result}) do
    {:ok, result}
  end

  defp handle_api_response(%{"error" => errors}) do
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

  def signature(path, nonce, form_data, secret) do
    params = URI.encode_query(form_data)
    sha_sum = :crypto.hash(:sha256, nonce <> params)
    mac_sum = :crypto.hmac(:sha512, secret, path <> sha_sum)
    Base.encode64(mac_sum)
  end
end
