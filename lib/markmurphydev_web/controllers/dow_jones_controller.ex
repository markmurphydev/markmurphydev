defmodule MarkmurphydevWeb.DowJonesController do
  use MarkmurphydevWeb, :controller

  def show(conn, %{}) do
    price_data = DowJones.get_price()
    json(conn, price_data)
  end
end
