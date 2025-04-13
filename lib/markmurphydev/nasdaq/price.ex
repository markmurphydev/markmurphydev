defmodule Markmurphydev.Nasdaq.Price do
  use Ecto.Schema
  import Ecto.Changeset

  schema "nasdaq_prices" do
    field :closing_price, :float
    field :recorded_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(price, attrs) do
    price
    |> cast(attrs, [:closing_price, :recorded_at])
    |> validate_required([:closing_price, :recorded_at])
  end
end
