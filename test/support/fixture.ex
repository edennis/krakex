defmodule Krakex.Fixture do
  @fixtures_dir "test/fixtures"

  def load!(fixture) do
    file = @fixtures_dir <> "/" <> fixture <> ".json"
    file |> File.read!() |> Poison.decode!()
  end
end
