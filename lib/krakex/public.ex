defmodule Krakex.Public do
  @base_path "/0/public/"

  def request(client, resource, opts \\ []) do
    url = client.endpoint <> path(resource)

    opts =
      case opts[:params] do
        params when is_list(params) ->
          Keyword.put(opts, :params, process_params(params))

        _ ->
          opts
      end

    case HTTPoison.get(url, [], opts) do
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
