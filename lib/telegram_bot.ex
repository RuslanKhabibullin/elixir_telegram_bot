require Bot.Supervisor
require Logger

defmodule TelegramBot do
  use Application

  def start(_type, _args) do
    Logger.log(:info, "Stating the application...")
    Bot.Supervisor.start_link
  end
end
