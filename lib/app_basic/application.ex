defmodule AppBasic.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AppBasicWeb.Telemetry,
      AppBasic.Repo,
      {DNSCluster, query: Application.get_env(:app_basic, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AppBasic.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AppBasic.Finch},
      # Start a worker by calling: AppBasic.Worker.start_link(arg)
      # {AppBasic.Worker, arg},
      # Start to serve requests, typically the last entry
      AppBasicWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AppBasic.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AppBasicWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
