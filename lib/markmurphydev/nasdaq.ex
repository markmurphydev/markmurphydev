defmodule Markmurphydev.Nasdaq do
  def today() do
    DateTime.now!("America/New_York")
    |> DateTime.to_date()
  end

  def nasdaq_request() do
    api_key = Application.get_env(:markmurphydev, :polygon_api_key)
    # Nasdaq 100 -- It's the only one Polygon will let me seeeee
    dow_jones_ticker = "I:NDX"
    timespan_increment = 1
    timespan_unit = "minute"

    today = today()
    day_before = today |> Date.add(-2) |> to_string
    yesterday = today |> Date.add(-1) |> to_string

    "https://api.polygon.io/v2/aggs/ticker/#{dow_jones_ticker}" <>
      "/range/#{timespan_increment}/#{timespan_unit}/#{day_before}/#{yesterday}?sort=asc&apiKey=#{api_key}"
  end

  def get_nasdaq() do
    res = nasdaq_request() |> Req.get!()
  end
end
