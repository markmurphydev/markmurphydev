defmodule Markmurphydev.Repo.Migrations.CreatePrices do
  use Ecto.Migration

  def change do
    create table(:prices) do
      add :price, :float
      add :price_change, :float
      add :listed_time, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
