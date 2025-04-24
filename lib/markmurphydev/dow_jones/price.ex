defmodule Markmurphydev.DowJones.Price do
  use Ecto.Schema
  import Ecto.Changeset

  schema "prices" do
    field :price, :float
    field :price_change, :float
    field :listed_time, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(price, attrs) do
    price
    |> cast(attrs, [:price, :price_change, :listed_time])
    |> validate_required([:price, :price_change, :listed_time])
  end
end
