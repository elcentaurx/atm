defmodule AtmApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      AtmApp.Repo,
      # Start the Telemetry supervisor
      AtmAppWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: AtmApp.PubSub},
      # Start the Endpoint (http/https)
      AtmAppWeb.Endpoint
      # Start a worker by calling: AtmApp.Worker.start_link(arg)
      # {AtmApp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AtmApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AtmAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
