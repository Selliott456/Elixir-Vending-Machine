defmodule Match_MVP.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      Match_MVPWeb.Telemetry,
      # Start the Ecto repository
      Match_MVP.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Match_MVP.PubSub},
      # Start Finch
      {Finch, name: Match_MVP.Finch},
      # Start the Endpoint (http/https)
      Match_MVPWeb.Endpoint
      # Start a worker by calling: Match_MVP.Worker.start_link(arg)
      # {Match_MVP.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Match_MVP.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Match_MVPWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
