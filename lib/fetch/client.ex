require Fetch.ClientBehaviour

defmodule Fetch.Client do
  @moduledoc """
  Realize HTTP Fetch Interface. Wrapper for different HTTP clients  
  """

  @behaviour Fetch.ClientBehaviour

  @http_client Application.get_env(:telegram_bot, :http_client)

  @spec get(binary, list[{atom, any}], list[{atom, any}]) :: tuple
  def get(url, headers \\ [], options \\ []), do: @http_client.get(url, headers, options)
end
