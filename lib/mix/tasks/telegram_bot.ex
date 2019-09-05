require Bot.Supervisor
require Logger

defmodule Mix.Tasks.TelegramBot do
  @moduledoc """
  Entry point for TelegramBot application. Starts Bot.Supervisor and Server.Supervisor on app start
  """

  use Mix.Task

  @shortdoc "Starts telegram bot worker"
  def run(_) do
    Logger.log(:info, "Stating the telegram bot...")
    Bot.Supervisor.start_link
  end
end
