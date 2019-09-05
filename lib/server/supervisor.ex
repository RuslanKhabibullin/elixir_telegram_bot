require Server.Router
require Logger

defmodule Server.Supervisor do
  @moduledoc """
  Supervisor for Server
  Needed to Heroku deployment(heroku kills Bot processes)
  """

  @doc false
  def start_link do
    Supervisor.start_link(__MODULE__, [], name: :server_supervisor)
  end

  @doc false
  def init([]) do
    Supervisor.init(
      [Plug.Cowboy.child_spec(scheme: :http, plug: Server.Router, options: [port: server_port()])],
      [strategy: :one_for_one]
    )
  end

  defp server_port do
    Application.get_env(:telegram_bot, :server_port)
    |> String.to_integer
  end
end
