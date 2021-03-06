defmodule Krakex.Util do
  @moduledoc false

  def timestamp_to_datetime(nil), do: nil

  def timestamp_to_datetime(string) when is_binary(string) do
    unix = String.to_float(string)
    us = round(unix * 1_000_000)
    DateTime.from_unix!(us, :microsecond)
  end
end
