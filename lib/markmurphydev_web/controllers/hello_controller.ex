defmodule MarkmurphydevWeb.HelloController do
  use MarkmurphydevWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
