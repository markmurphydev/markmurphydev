defmodule DowJones do
  alias DowJones.ListedDateTime
  alias Markmurphydev.{Repo, DowJones.Price}

  defp url, do: "https://finance.yahoo.com/quote/%5EDJI/"

  # -> Markmurphydev.DowJones.Price
  def get_price() do
    doc =
      Req.get!(url()).body
      |> Floki.parse_document!()

    [price(doc), price_diff(doc), ListedDateTime.listed_date_time(doc)]
  end

  defp price(doc) do
    {_, _, [price_str]} =
      doc
      |> Floki.find("span[data-testid=qsp-price]")
      |> List.first()

    price_str
    |> String.trim()
    |> String.replace(",", "")
    |> String.to_float()
  end

  defp price_diff(doc) do
    {_, _, [price_diff_str]} =
      doc
      |> Floki.find("span[data-testid=qsp-price-change]")
      |> List.first()

    price_diff_str
    |> String.trim()
    |> String.replace(",", "")
    |> String.to_float()
  end

  defmodule ListedDateTime do
    @moduledoc false
    defp time_zone, do: "America/New_York"
    defp this_year, do: Timex.now(time_zone()).year

    def date_time_from_str(date_time_str) do
      cond do
        date_time_str |> String.starts_with?("At close:") -> at_close(date_time_str)
        true -> raise "Unknown datetime format: " <> date_time_str
      end
    end

    defp at_close(time_str) do
      %{"day" => day, "time" => time} =
        ~r/At close: (?<day>\w+ \w+) at (?<time>.* (AM|PM)).*/
        |> Regex.named_captures(time_str)

      date_time_str = day <> " " <> time
      parse_date_time(date_time_str)
    end

    defp parse_date_time(date_time_str) do
      {:ok, date_time} = date_time_str |> Timex.parse("{Mfull} {0D} {h12}:{m}:{s} {AM}")
      # Defaults the year to "0000". Change it to this year.
      date_time = %{date_time | year: this_year()}
      date_time |> DateTime.from_naive!(time_zone())
    end

    def listed_date_time(doc) do
      {_, _, [date_time_str]} =
        doc
        |> Floki.find("div[slot=marketTimeNotice] span span")
        |> List.first()

      parse_date_time(date_time_str)
    end
  end
end
