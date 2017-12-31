defmodule Krakex do
  @moduledoc """
  Documentation for Krakex.
  """

  alias Krakex.{API, Client}

  defmodule MissingConfigError do
    defexception [:message]
  end

  def server_time(client \\ client()) do
    API.public_request(client, "Time")
  end

  def assets(client \\ client()) do
    API.public_request(client, "Assets")
  end

  def asset_pairs(client \\ client()) do
    API.public_request(client, "AssetPairs")
  end

  def ticker(client \\ client(), pairs) when is_list(pairs) do
    API.public_request(client, "Ticker", pair: pairs)
  end

  # An open-high-low-close chart (also OHLC) is a type of chart typically used to illustrate movements in the price of a financial instrument over time. Each vertical line on the chart shows the price range (the highest and lowest prices) over one unit of time, e.g., one day or one hour
  def ohlc(client \\ client(), pair, opts \\ []) do
    API.public_request(client, "OHLC", [pair: pair] ++ opts)
  end

  def depth(client \\ client(), pair, opts \\ []) do
    API.public_request(client, "Depth", [pair: pair] ++ opts)
  end

  def trades(client \\ client(), pair, opts \\ []) do
    API.public_request(client, "Trades", [pair: pair] ++ opts)
  end

  def spread(client \\ client(), pair, opts \\ []) do
    API.public_request(client, "Spread", [pair: pair] ++ opts)
  end

  def balance(client \\ private_client()) do
    API.private_request(client, "Balance")
  end

  def trade_balance(client \\ private_client()) do
    API.private_request(client, "TradeBalance")
  end

  def open_orders(client \\ private_client()) do
    API.private_request(client, "OpenOrders")
  end

  def closed_orders(client \\ private_client(), opts \\ [])

  def closed_orders(%Client{} = client, opts) when is_list(opts) do
    API.private_request(client, "ClosedOrders", opts)
  end

  def closed_orders(opts, []) do
    API.private_request(private_client(), "ClosedOrders", opts)
  end

  def query_orders(tx_ids, client \\ private_client()) do
    API.private_request(client, "QueryOrders", txid: tx_ids)
  end

  def trades_history(client \\ private_client(), opts) do
    API.private_request(client, "TradesHistory", opts)
  end

  def query_trades(client \\ private_client(), tx_ids, opts) do
    API.private_request(client, "QueryTrades", [txid: tx_ids] ++ opts)
  end

  def open_positions(client \\ private_client(), tx_ids, opts) do
    API.private_request(client, "OpenPositions", [txid: tx_ids] ++ opts)
  end

  def ledgers(client \\ private_client(), opts) do
    API.private_request(client, "Ledgers", opts)
  end

  def query_ledgers(client \\ private_client(), ids) do
    API.private_request(client, "QueryLedgers", id: ids)
  end

  def trade_volume(client \\ private_client()) do
    API.private_request(client, "TradeVolume", [])
  end

  # TODO: add_order, cancel_order

  defp client do
    Client.new()
  end

  defp private_client do
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
end
