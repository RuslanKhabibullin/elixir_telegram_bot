defmodule Telegram.ClientBehaviour do
  @moduledoc """
  Defines interface for Telegram Client - on prod and dev used Nadia library
  """

  @typep options :: [{atom, any}]
  @typep chat_id :: integer
  @typep message :: binary
  @typep photo :: binary

  @callback get_updates(options) :: {:ok, [map]} | {:error, map}
  @callback send_message(chat_id, message, options) :: {:ok, map} | {:error, map}
  @callback send_message(chat_id, message) :: {:ok, map} | {:error, map}
  @callback send_photo(chat_id, photo, options) :: {:ok, map} | {:error, map}
  @callback send_photo(chat_id, photo) :: {:ok, map} | {:error, map}
end
