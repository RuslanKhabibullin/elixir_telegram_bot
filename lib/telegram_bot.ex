require Bot.Supervisor
require Logger

defmodule TelegramBot do
  @moduledoc """
  Entry point for TelegramBot application. Starts Bot.Supervisor on app start
  """

  use Application

  @doc false
  def start(_type, _args) do
    Logger.log(:info, "Stating the application...")
    Bot.Supervisor.start_link
  end
end
