require Bot.Poller
require Bot.ReplyHandler

defmodule Bot.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], [name: :bot_supervisor])
  end

  def init([]) do
    children = [
      worker(Bot.Poller, []),
      worker(Bot.ReplyHandler, [])
    ]

    supervise(children, [strategy: :one_for_one])
  end
end
