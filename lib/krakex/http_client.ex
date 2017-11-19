defmodule Krakex.HTTPClient do
  @moduledoc """
  This module abstracts the usage of the underlying http client and additionally takes care of
  decoding JSON as well as HTTP error handling.
  """

  @typedoc "The client's return type"
  @type response :: {:ok, term} | {:error, term}

  @client HTTPoison
  @headers [{"accept", "application/json"}, {"content-type", "application/x-www-form-urlencoded"}]

  @spec post(url :: String.t(), form_data :: keyword, headers :: list, client :: module) ::
          response
  def post(url, form_data, headers, client \\ @client)
      when is_binary(url) and is_list(form_data) and is_list(headers) do
    response = client.post(url, {:form, form_data}, headers ++ @headers)
    handle_response(response)
  end

  defp handle_response({:ok, response}), do: handle_http_response(response)
  defp handle_response({:error, %{reason: reason}}), do: {:error, reason}

  defp handle_http_response(%{status_code: status_code, body: body}) when status_code in 200..206 do
    case Poison.decode(body) do
      {:ok, decoded} -> {:ok, decoded}
      {:error, :invalid, _} -> {:error, {:invalid, body}}
      {:error, {:invalid, _, _}} -> {:error, {:invalid, body}}
    end
  end

  defp handle_http_response(%{status_code: status_code, body: body}),
    do: {:error, {status_code, body}}
end
