defmodule Krakex.Public do
  @behaviour Krakex.API

  alias Krakex.{API, Client, HTTPClient}

  @base_path "/0/public/"

  def request(%Client{} = client, resource, opts \\ []) do
    url = client.endpoint <> path(resource)

    form_data = API.process_params(opts)

    case HTTPClient.post(url, form_data, []) do
      {:ok, response} ->
        API.handle_response(response)

      {:error, reason} ->
        {:error, reason}
    end
  end

  def path(resource) do
    @base_path <> resource
  end
end
