defmodule Markmurphydev.Repo.Migrations.CreateNasdaqPrices do
  use Ecto.Migration

  def change do
    create table(:nasdaq_prices) do
      add :closing_price, :float
      add :recorded_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
