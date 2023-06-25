defmodule Trackdays.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      TrackdaysWeb.Telemetry,
      # Start the Ecto repository
      Trackdays.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Trackdays.PubSub},
      # Start Finch
      {Finch, name: Trackdays.Finch},
      # Start the Endpoint (http/https)
      TrackdaysWeb.Endpoint
      # Start a worker by calling: Trackdays.Worker.start_link(arg)
      # {Trackdays.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Trackdays.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TrackdaysWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
