defmodule Markmurphydev.Nasdaq do
  alias Markmurphydev.{Repo, Nasdaq.Price}

  defp today() do
    DateTime.now!("America/New_York")
    |> DateTime.to_date()
  end

  defp nasdaq_request() do
    [polygon_api_key: api_key] = Application.get_env(:markmurphydev, Markmurphydev.Nasdaq)
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

  defp to_price(%{"c" => closing_price, "t" => timestamp}) do
    recorded_at =
      timestamp
      |> DateTime.from_unix!(:millisecond)
      |> DateTime.truncate(:second)

    %Price{closing_price: closing_price, recorded_at: recorded_at}
  end

  defp res_to_prices(%{status: 200, body: body}) do
    body["results"] |> Enum.map(&to_price/1)
  end

  @doc """
  Get nasdaq data from the day before yesterday, and save it to the database.
  """
  def get_nasdaq() do
    prices = nasdaq_request() |> Req.get!() |> res_to_prices()
    Enum.each(prices, &Repo.insert/1)
  end
end
