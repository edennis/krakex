defmodule Krakex.Websocket do
  def ticker(client, pairs, callback) do
    WebSockex.cast(client, {:subscribe, "ticker", pairs, callback, []})
  end

  # opts: interval: Default 1. Valid Interval values: 1|5|15|30|60|240|1440|10080|21600
  def ohlc(client, pairs, callback, opts \\ []) do
    interval = Keyword.get(opts, :interval, 1)
    WebSockex.cast(client, {:subscribe, "ohlc", pairs, callback, interval: interval})
  end

  def trade(client, pairs, callback) do
    WebSockex.cast(client, {:subscribe, "trade", pairs, callback, []})
  end

  def spread(client, pairs, callback) do
    WebSockex.cast(client, {:subscribe, "spread", pairs, callback, []})
  end

  # opts: depth	: depth associated with book subscription in number of levels each side, default 10. Valid Options are: 10, 25, 100, 500, 1000
  def book(client, pairs, callback, opts \\ []) do
    depth = Keyword.get(opts, :depth, 10)
    WebSockex.cast(client, {:subscribe, "book", pairs, callback, depth: depth})
  end
end
