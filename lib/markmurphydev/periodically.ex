defmodule Markmurphydev.Periodically do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()
    {:noreply, state}
  end

  def handle_info(:work, state) do
    # ... DO WORK HERE ...
    {:noreplyl, state}
  end

  defp schedule_work() do
    # 2 hours
    Process.send_after(self(), :work, 2 * 60 * 60 * 1000)
  end
end
