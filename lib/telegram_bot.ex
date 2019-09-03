require Bot.Supervisor
require Server.Supervisor
require Logger

defmodule TelegramBot do
  @moduledoc """
  Entry point for TelegramBot application. Starts Bot.Supervisor and Server.Supervisor on app start
  """

  use Application

  @doc false
  def start(_type, _args) do
    Logger.log(:info, "Stating the application...")
    Bot.Supervisor.start_link
    Logger.log(:info, "Web Server stated...")
    Server.Supervisor.start_link
  end
end
