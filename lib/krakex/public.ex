defmodule Krakex.Public do
  alias Krakex.HTTPClient

  @base_path "/0/public/"

  def request(client, resource, opts \\ []) do
    url = client.endpoint <> path(resource)

    form_data = process_params(opts)

    case HTTPClient.post(url, form_data, []) do
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
