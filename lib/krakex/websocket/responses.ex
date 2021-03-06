defmodule Krakex.Websocket.TickerResponse do
  defstruct pair: nil,
            ask: %{},
            bid: %{},
            close: %{},
            volume: %{},
            volume_weighted_avg: %{},
            trades: %{},
            low_price: %{},
            high_price: %{},
            open_price: %{}

  def from_payload(pair, %{} = payload) do
    %__MODULE__{
      pair: pair,
      ask: askbid_from_list(payload["a"]),
      bid: askbid_from_list(payload["b"]),
      close: value_from_list(payload["c"]),
      volume: value_from_list(payload["v"]),
      volume_weighted_avg: value_from_list(payload["p"]),
      trades: value_from_list(payload["t"]),
      low_price: value_from_list(payload["l"]),
      high_price: value_from_list(payload["h"]),
      open_price: value_from_list(payload["o"])
    }
  end

  defp askbid_from_list([price, whole_lot_volume, lot_volume]) do
    %{price: price, whole_lot_volume: whole_lot_volume, lot_volume: lot_volume}
  end

  defp value_from_list([today, last_24_hours]) do
    %{today: today, last_24_hours: last_24_hours}
  end
end

defmodule Krakex.Websocket.OhlcResponse do
  alias Krakex.Util

  defstruct [:pair, :interval, :time, :etime, :open, :high, :low, :close, :vwap, :volume, :count]

  def from_payload(pair, interval, payload) when is_list(payload) do
    [time, etime, open, high, low, close, vwap, volume, count] = payload

    %__MODULE__{
      pair: pair,
      interval: interval,
      time: Util.timestamp_to_datetime(time),
      etime: Util.timestamp_to_datetime(etime),
      open: open,
      high: high,
      low: low,
      close: close,
      vwap: vwap,
      volume: volume,
      count: count
    }
  end
end

defmodule Krakex.Websocket.TradeResponse do
  alias Krakex.Util

  defstruct [:pair, :price, :volume, :time, :side, :order_type, :misc]

  def from_payload(pair, payload) when is_list(payload) do
    payload |> Enum.map(&from_list(pair, &1))
  end

  defp from_list(pair, [price, volume, time, side, order_type, misc]) do
    %__MODULE__{
      pair: pair,
      price: price,
      volume: volume,
      time: Util.timestamp_to_datetime(time),
      side: convert_side(side),
      order_type: convert_order_type(order_type),
      misc: misc
    }
  end

  defp convert_side("b"), do: "buy"
  defp convert_side("s"), do: "sell"

  defp convert_order_type("l"), do: "limit"
  defp convert_order_type("m"), do: "market"
end

defmodule Krakex.Websocket.SpreadResponse do
  alias Krakex.Util

  defstruct [:pair, :bid, :ask, :timestamp, :bid_volume, :ask_volume]

  def from_payload(pair, payload) when is_list(payload) do
    [bid, ask, timestamp, bid_volume, ask_volume] = payload

    %__MODULE__{
      pair: pair,
      bid: bid,
      ask: ask,
      timestamp: Util.timestamp_to_datetime(timestamp),
      bid_volume: bid_volume,
      ask_volume: ask_volume
    }
  end
end

defmodule Krakex.Websocket.BookSnapshotResponse do
  alias Krakex.Util

  defstruct [:pair, :depth, asks: [], bids: []]

  def from_payload(pair, depth, %{} = payload) do
    asks = Map.get(payload, "as", [])
    bids = Map.get(payload, "bs", [])

    %__MODULE__{
      pair: pair,
      depth: depth,
      asks: Enum.map(asks, &price_level_from_list/1),
      bids: Enum.map(bids, &price_level_from_list/1)
    }
  end

  defp price_level_from_list([price, volume, timestamp]) do
    %{price: price, volume: volume, timestamp: Util.timestamp_to_datetime(timestamp)}
  end
end

defmodule Krakex.Websocket.BookUpdateResponse do
  alias Krakex.Util

  defstruct [:pair, :depth, asks: [], bids: []]

  def from_payload(pair, depth, %{} = payload) do
    asks = Map.get(payload, "a", [])
    bids = Map.get(payload, "b", [])

    %__MODULE__{
      pair: pair,
      depth: depth,
      asks: Enum.map(asks, &price_level_from_list/1),
      bids: Enum.map(bids, &price_level_from_list/1)
    }
  end

  defp price_level_from_list([price, volume, timestamp]) do
    %{
      price: price,
      volume: volume,
      timestamp: Util.timestamp_to_datetime(timestamp),
      update_type: nil
    }
  end

  defp price_level_from_list([price, volume, timestamp, _update_type]) do
    %{
      price: price,
      volume: volume,
      timestamp: Util.timestamp_to_datetime(timestamp),
      update_type: "republished"
    }
  end
end

defmodule Krakex.Websocket.BookResponse do
  alias Krakex.Websocket.{BookSnapshotResponse, BookUpdateResponse}

  def from_payload(pair, depth, %{"as" => _, "bs" => _} = payload),
    do: BookSnapshotResponse.from_payload(pair, depth, payload)

  def from_payload(pair, depth, payload),
    do: BookUpdateResponse.from_payload(pair, depth, payload)
end

defmodule Krakex.Websocket.OwnTradeResponse do
  alias Krakex.Util

  defstruct [
    :tradeid,
    :ordertxid,
    :postxid,
    :pair,
    :time,
    :type,
    :order_type,
    :price,
    :cost,
    :fee,
    :volume,
    :margin,
    :userref
  ]

  def from_payload(payload) when is_list(payload) do
    payload
    |> Enum.map(fn obj ->
      Enum.map(obj, fn {tradeid, trade} ->
        %__MODULE__{
          tradeid: tradeid,
          ordertxid: trade["ordertxid"],
          postxid: trade["postxid"],
          pair: trade["pair"],
          time: Util.timestamp_to_datetime(trade["time"]),
          type: trade["type"],
          order_type: trade["ordertype"],
          price: trade["price"],
          cost: trade["cost"],
          fee: trade["fee"],
          volume: trade["volume"],
          margin: trade["margin"],
          userref: trade["userref"]
        }
      end)
    end)
  end
end

defmodule Krakex.Websocket.OpenOrderResponse do
  alias Krakex.Util

  defstruct [
    :orderid,
    :refid,
    :userref,
    :status,
    :opentm,
    :starttm,
    :expiretm,
    :vol,
    :vol_exec,
    :cost,
    :fee,
    :avg_price,
    :stopprice,
    :limitprice,
    :misc,
    :oflags,
    :timeinforce,
    :cancel_reason,
    :ratecount,
    descr: %{}
  ]

  def from_payload(payload) when is_list(payload) do
    payload |> Enum.map(fn obj -> Enum.map(obj, &from_object/1) end)
  end

  defp from_object({orderid, %{} = order}) do
    %__MODULE__{
      orderid: orderid,
      refid: order["refid"],
      userref: order["userref"],
      status: order["status"],
      opentm: Util.timestamp_to_datetime(order["opentm"]),
      starttm: Util.timestamp_to_datetime(order["starttm"]),
      expiretm: Util.timestamp_to_datetime(order["expiretm"]),
      vol: order["vol"],
      vol_exec: order["vol_exec"],
      cost: order["cost"],
      fee: order["fee"],
      avg_price: order["avg_price"],
      stopprice: order["stopprice"],
      limitprice: order["limitprice"],
      # this is not documented but "touched seems to be returned in the "flags" field
      misc: order["misc"] || order["flags"],
      oflags: order["oflags"],
      timeinforce: order["timeinforce"],
      cancel_reason: order["cancel_reason"],
      ratecount: order["ratecount"],
      descr: %{
        pair: order["descr"]["pair"],
        position: order["descr"]["position"],
        type: order["descr"]["type"],
        ordertype: order["descr"]["ordertype"],
        price: order["descr"]["price"],
        price2: order["descr"]["price2"],
        leverage: order["descr"]["leverage"],
        order: order["descr"]["order"],
        close: order["descr"]["close"]
      }
    }
  end
end
