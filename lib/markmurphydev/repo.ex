defmodule Markmurphydev.Repo do
  use Ecto.Repo,
    otp_app: :markmurphydev,
    adapter: Ecto.Adapters.Postgres
end
