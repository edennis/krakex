defmodule Krakex.Websocket.Client do
  use WebSockex

  alias Krakex.Websocket.{
    BookResponse,
    OhlcResponse,
    OpenOrderResponse,
    OwnTradeResponse,
    SpreadResponse,
    TickerResponse,
    TradeResponse
  }

  @url "wss://ws.kraken.com"
  @auth_url "wss://ws-auth.kraken.com"

  defmodule State do
    @moduledoc false
    defstruct callbacks: %{},
              heartbeats: 0,
              subscriptions: MapSet.new(),
              private: false,
              token: nil
  end

  def start_link(opts \\ []) do
    {private, opts} = Keyword.pop(opts, :private)

    if private do
      {:ok, %{"token" => token}} = Krakex.websockets_token()
      WebSockex.start_link(@auth_url, __MODULE__, %State{private: true, token: token}, opts)
    else
      WebSockex.start_link(@url, __MODULE__, %State{}, opts)
    end
  end

  def handle_connect(_conn, state) do
    IO.puts("connected!")
    {:ok, state}
  end

  def handle_cast({:subscribe, name, pairs, callback, opts}, state) do
    {frame, callbacks} =
      if state.private do
        callbacks = %{name => callback}
        {subscription_frame(name, pairs, Keyword.merge(opts, token: state.token)), callbacks}
      else
        callbacks = for pair <- pairs, cb <- [callback], into: %{}, do: {{name, pair}, cb}
        {subscription_frame(name, pairs, opts), callbacks}
      end

    {:reply, frame, %{state | callbacks: Map.merge(state.callbacks, callbacks)}}
  end

  def handle_disconnect(_conn, state) do
    IO.puts("disconnected")
    {:ok, state}
  end

  def handle_frame({:text, msg}, state) do
    case Jason.decode(msg) do
      {:ok, decoded} ->
        handle_msg(decoded, state)

      {:error, %Jason.DecodeError{} = error} ->
        IO.puts("error decoding json: #{msg}, error: #{Jason.DecodeError.message(error)}")
        {:ok, state}
    end
  end

  def handle_msg(%{"event" => "heartbeat"}, state) do
    {:ok, %{state | heartbeats: state.heartbeats + 1}}
  end

  # public api
  def handle_msg(
        %{
          "event" => "subscriptionStatus",
          "pair" => pair,
          "channelID" => channel_id,
          "subscription" => %{"name" => name}
        },
        state
      ) do
    {:ok, %{state | subscriptions: MapSet.put(state.subscriptions, {channel_id, name, pair})}}
  end

  # private api
  def handle_msg(%{"event" => "subscriptionStatus", "channelName" => channel_name}, state) do
    {:ok, %{state | subscriptions: MapSet.put(state.subscriptions, channel_name)}}
  end

  def handle_msg([_channel_id, payload, "ticker", pair], state) do
    response = TickerResponse.from_payload(pair, payload)
    state.callbacks[{"ticker", pair}].(response)

    {:ok, state}
  end

  def handle_msg([_channel_id, payload, "ohlc-" <> interval, pair], state) do
    response = OhlcResponse.from_payload(pair, interval, payload)
    state.callbacks[{"ohlc", pair}].(response)

    {:ok, state}
  end

  def handle_msg([_channel_id, payload, "trade", pair], state) do
    response = TradeResponse.from_payload(pair, payload)
    state.callbacks[{"trade", pair}].(response)

    {:ok, state}
  end

  def handle_msg([_channel_id, payload, "spread", pair], state) do
    response = SpreadResponse.from_payload(pair, payload)
    state.callbacks[{"spread", pair}].(response)

    {:ok, state}
  end

  def handle_msg([_channel_id, payload, "book-" <> depth, pair], state) do
    response = BookResponse.from_payload(pair, depth, payload)
    state.callbacks[{"book", pair}].(response)

    {:ok, state}
  end

  def handle_msg([payload, "ownTrades", %{"sequence" => _}], state) do
    response = OwnTradeResponse.from_payload(payload)
    state.callbacks["ownTrades"].(response)

    {:ok, state}
  end

  def handle_msg([payload, "openOrders", %{"sequence" => _}], state) do
    response = OpenOrderResponse.from_payload(payload)
    state.callbacks["openOrders"].(response)

    {:ok, state}
  end

  def handle_msg(msg, state) do
    IO.inspect(msg, label: "not handled")

    {:ok, state}
  end

  defp subscription_frame(name, pairs, opts) do
    payload = %{
      event: "subscribe",
      subscription: Map.merge(%{name: name}, Map.new(opts))
    }

    payload =
      if pairs == [] do
        payload
      else
        Map.merge(payload, %{pair: pairs})
      end

    {:text, Jason.encode!(payload)}
  end
end
