defmodule LedsPlay do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(LedsPlay.Repo, []),
      # Start the endpoint when the application starts
      supervisor(LedsPlay.Endpoint, []),
      
      worker(LedsPlay.Strip, [%{pin: 18, count: 200}]),
      worker(LedsPlay.Grid, [20, 10]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LedsPlay.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    LedsPlay.Endpoint.config_change(changed, removed)
    :ok
  end
end
