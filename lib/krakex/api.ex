defmodule Krakex.API do
  @callback request(client :: Krakex.Client.t(), resource :: binary, opts :: keyword) ::
              {:ok, any} | {:error, any}

  @callback path(resource :: binary) :: binary

  def handle_response(%{"error" => [], "result" => result}) do
    {:ok, result}
  end

  def handle_response(%{"error" => errors}) do
    {:error, hd(errors)}
  end

  def process_params(params) do
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
