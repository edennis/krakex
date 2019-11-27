defmodule Krakex.HTTPClient do
  @moduledoc false

  @type response :: {:ok, term} | {:error, term}

  @client :hackney
  @headers [{"accept", "application/json"}]
  @post_headers @headers ++ [{"content-type", "application/x-www-form-urlencoded"}]

  @spec get(url :: String.t(), params :: keyword, headers :: list, client :: module) :: response
  def get(url, params, headers, client \\ @client)
      when is_binary(url) and is_list(params) and is_list(headers) do
    url = build_request_url(url, params)
    response = client.get(url, headers ++ @headers)
    handle_response(response)
  end

  @spec post(url :: String.t(), form_data :: keyword, headers :: list, client :: module) ::
          response
  def post(url, form_data, headers, client \\ @client)
      when is_binary(url) and is_list(form_data) and is_list(headers) do
    response = client.post(url, {:form, form_data}, headers ++ @post_headers)
    handle_response(response)
  end

  def build_request_url(url, nil), do: url

  def build_request_url(url, params) do
    cond do
      Enum.count(params) === 0 -> url
      URI.parse(url).query -> url <> "&" <> URI.encode_query(params)
      true -> url <> "?" <> URI.encode_query(params)
    end
  end

  defp handle_response({:ok, status_code, _headers, client_ref}) when status_code in 200..206 do
    {:ok, response_body} = :hackney.body(client_ref)

    case Jason.decode(response_body) do
      {:ok, decoded} ->
        {:ok, decoded}

      {:error, %Jason.DecodeError{}} ->
        {:error, {:invalid, response_body}}
    end
  end

  defp handle_response({:error, reason}), do: {:error, reason}

  defp handle_http_response(%{status_code: status_code, body: body}),
    do: {:error, {status_code, body}}
end
