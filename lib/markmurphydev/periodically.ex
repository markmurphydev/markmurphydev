defmodule Markmurphydev.Periodically do
  require Logger
  alias Markmurphydev.Nasdaq
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send(self(), :work, [])
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    Nasdaq.get_nasdaq()

    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    # 2 hours in ms
    Process.send_after(self(), :work, 6 * 60 * 60 * 1000)
  end
end
