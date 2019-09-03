require Server.Router
require Logger

defmodule Server.Supervisor do
  @moduledoc """
  Supervisor for Server
  Needed to Heroku deployment(heroku kills Bot processes)
  """

  @doc false
  def start_link do
    Supervisor.start_link(__MODULE__, [], [name: :server_supervisor])
  end

  @doc false
  def init([]) do
    port = System.get_env("PORT", "8085") |> String.to_integer
    children = [
      Plug.Cowboy.child_spec(scheme: :http, plug: Server.Router, options: [port: port])
    ]

    Supervisor.init(children, [strategy: :one_for_one])
  end
end
