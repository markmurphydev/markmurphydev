defmodule Markmurphydev.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MarkmurphydevWeb.Telemetry,
      Markmurphydev.Repo,
      {DNSCluster, query: Application.get_env(:markmurphydev, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Markmurphydev.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Markmurphydev.Finch},
      # Start a worker by calling: Markmurphydev.Worker.start_link(arg)
      # {Markmurphydev.Worker, arg},
      # Start to serve requests, typically the last entry
      MarkmurphydevWeb.Endpoint,
      Markmurphydev.Periodically
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Markmurphydev.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MarkmurphydevWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
