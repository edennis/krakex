defmodule Krakex.Client do
  @endpoint "https://api.kraken.com"

  defstruct endpoint: @endpoint, key: nil, secret: nil

  @type t :: %__MODULE__{endpoint: binary, key: binary, secret: binary}

  @spec new() :: t
  def new(), do: %__MODULE__{}

  @spec new(api_key :: binary, private_key :: binary, endpoint :: binary) :: t
  def new(api_key, private_key, endpoint \\ @endpoint)
      when is_binary(api_key) and is_binary(private_key) and is_binary(endpoint) do
    %__MODULE__{endpoint: endpoint, key: api_key, secret: decode_private_key(private_key)}
  end

  defp decode_private_key(private_key) do
    case Base.decode64(private_key) do
      {:ok, secret} ->
        secret

      :error ->
        raise "private_key is not Base64 encoded: #{inspect(private_key)}"
    end
  end
end
