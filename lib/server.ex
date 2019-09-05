require Server.Supervisor
require Logger

defmodule Server do
  @moduledoc """
  Entry point for Server part of application. Simply run webserver with only one root endpoint
  """

  use Application

  @doc false
  def start(_type, _args) do
    Logger.log(:info, "Stating the server...")
    Server.Supervisor.start_link
  end
end
