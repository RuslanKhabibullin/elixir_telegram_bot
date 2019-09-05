require Telegram.ClientBehaviour

defmodule Telegram.Client do
  @moduledoc """
  Realize Telegram Client Interface. Wrapper for Nadia client library  
  """

  @behaviour Telegram.ClientBehaviour

  @telegram_client Application.get_env(:telegram_bot, :telegram_client)

  @spec get_updates([{atom, any}]) :: {:ok, [map]} | {:error, map}
  def get_updates(options \\ []), do: @telegram_client.get_updates(options)
  
  @spec send_message(integer, binary, [{atom, any}]) :: {:ok, map} | {:error, map}
  def send_message(chat_id, text, options \\ []), do: @telegram_client.send_message(chat_id, text, options)

  @spec send_photo(integer, binary, [{atom, any}]) :: {:ok, map} | {:error, map}
  def send_photo(chat_id, photo, options \\ []), do: @telegram_client.send_photo(chat_id, photo, options)
end
