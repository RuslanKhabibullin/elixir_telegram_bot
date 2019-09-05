require Bot.Supervisor
require Logger

defmodule Mix.Tasks.TelegramBot do
  @moduledoc """
  Entry point for TelegramBot application. Starts Bot.Supervisor and Server.Supervisor on app start
  """

  use Mix.Task

  @shortdoc "Starts telegram bot worker"
  def run(_) do
    # TODO: Refactor this. On Mix tasks deps not initialized.
    HTTPoison.start()
    task = Task.async(&recursive_supervisor/0)
    # Mix task exits on sync code finished. Dirty fix for infinite mix task
    Task.await(task, :infinity)
  end

  defp recursive_supervisor do
    if Process.whereis(:bot_supervisor) == nil do
      Logger.log(:info, "Stating the telegram bot...")
      Bot.Supervisor.start_link
    end
    
    if Mix.env() != :test, do: recursive_supervisor(), else: nil
  end
end
