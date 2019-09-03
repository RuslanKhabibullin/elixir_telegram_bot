require Bot.Poller
require Bot.ReplyHandler

defmodule Bot.Supervisor do
  @moduledoc """
  Supervisor for Bot workers: Poller and ReplyHandler.
  Needed to support work in these processes
  """

  use Supervisor

  @doc false
  def start_link do
    Supervisor.start_link(__MODULE__, [], [name: :bot_supervisor])
  end

  @doc false
  def init([]) do
    children = [
      worker(Bot.Poller, []),
      worker(Bot.ReplyHandler, [])
    ]

    supervise(children, [strategy: :one_for_one])
  end
end
