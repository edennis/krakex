defmodule Krakex.API do
  @moduledoc """
  Access to public and private APIs.

  This module defines functions for building calls for the public and private
  APIs and handles things such as request signing.
  """

  @type response :: {:ok, term} | {:error, any}

  alias Krakex.Client

  @public_path "/0/public/"
  @private_path "/0/private/"

  @doc """
  Access public API calls.
  """
  @spec public_request(Client.t(), binary, keyword) :: response
  def public_request(%Client{http_client: http_client} = client, resource, params \\ []) do
    url = client.endpoint <> public_path(resource)
    params = process_params(params)
    response = http_client.get(url, params, [])
    handle_http_response(response)
  end

  defmodule MissingConfigError do
    @moduledoc """
    Error raised when attempting to use private API functions without having specified
    values for the API and/or private keys.
    """

    defexception [:message]
  end

  defmodule MissingCredentialsError do
    @moduledoc """
    Error raised when attempting to use private API functions and the `Krakex.Client` struct
    didn't specify values for the API and/or private keys.
    """

    defexception [:message]
  end

  @doc """
  Access private API calls.

  It signs requests using the API and private keys.

  It will raise a `Krakex.API.MissingCredentialsError` if provided a `Krakex.Client` struct
  without values for either the API or private keys.
  """
  @spec private_request(Client.t(), binary, keyword) :: response
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

  @doc false
  @spec public_client() :: Client.t()
  def public_client do
    %Client{}
  end

  @doc false
  @spec private_client() :: Client.t()
  def private_client do
    config = Application.get_all_env(:krakex)

    case {config[:api_key], config[:private_key]} do
      {api_key, private_key} when is_binary(api_key) and is_binary(private_key) ->
        Client.new(config[:api_key], config[:private_key])

      _ ->
        raise MissingConfigError,
          message: """
          This API call requires an API key and a private key and I wasn't able to find them in your
          mix config. You need to define them like this:

          config :krakex,
            api_key: "KRAKEN_API_KEY",
            private_key: "KRAKEN_PRIVATE_KEY"
          """
    end
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
    mac_sum = :crypto.mac(:hmac, :sha512, secret, path <> sha_sum)
    Base.encode64(mac_sum)
  end

  defp handle_http_response({:ok, response}), do: handle_api_response(response)
  defp handle_http_response({:error, reason}), do: {:error, reason}

  defp handle_api_response(%{"error" => [], "result" => result}), do: {:ok, result}
  # Not sure if more than one error can occur - just take the first one.
  defp handle_api_response(%{"error" => errors}), do: {:error, hd(errors)}

  defp process_params(params) do
    params
    |> Enum.map(&param_mapper/1)
    |> List.flatten()
    |> Enum.reject(&is_empty/1)
  end

  defp param_mapper({k, v}) do
    cond do
      Keyword.keyword?(v) ->
        Enum.map(v, fn {mk, mv} -> {:"#{k}[#{mk}]", mv} end)

      is_list(v) ->
        {k, Enum.join(v, ",")}

      true ->
        {k, v}
    end
  end

  defp is_empty({_, v}) when v in [nil, ""], do: true
  defp is_empty(_), do: false
end
