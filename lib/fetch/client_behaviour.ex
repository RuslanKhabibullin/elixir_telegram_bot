defmodule Fetch.ClientBehaviour do
  @moduledoc """
  Defines interface for HTTP Clients - on prod and dev used HTTPoison
  """

  @typep url :: binary
  @typep headers :: [{atom, any}]
  @typep options :: [{atom, any}]

  @callback get(url, headers, options) :: tuple
  @callback get(url) :: tuple
end
