require Server.Supervisor
require Logger

defmodule Server do
  @moduledoc """
  Entry point for TelegramBot application. Starts webserver with socket endpoints
  """

  use Application

  @doc false
  def start(_type, _args) do
    Logger.log(:info, "Server started...")
    Server.Supervisor.start_link
  end
end
