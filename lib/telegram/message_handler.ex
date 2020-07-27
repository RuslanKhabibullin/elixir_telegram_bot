require Anime.Client
require Telegram.Client
require Telegram.MessageHandlerBehaviour

defmodule Telegram.MessageHandler do
  @moduledoc """
  Telegram message parsing logic
  """

  @behaviour Telegram.MessageHandlerBehaviour

  @start_message """
                 Hello! This is RuslanTestBot for elixir learning
                 Please use `/help` for commands
                 """
  @help_message """
                Usable commands:
                /anime_wallpaper - Get anime wallpaper
                """

  @doc """
  Telegram message response logic
  """
  @spec call(%{required(:message) => %{required(:text) => String.t, required(:chat) => %{required(:id) => integer}}}) :: true
  def call(%{"message" => %{"text" => text, "chat" => %{"id" => chat_id}}}) do
    case text do
      "/start" -> Telegram.Client.send_message(chat_id, @start_message)
      "/help" -> Telegram.Client.send_message(chat_id, @help_message)
      "/anime_wallpaper" -> Telegram.Client.send_photo(chat_id, Anime.Client.get_random_image.url)
      _ -> nil
    end
    true
  end

  def call(_), do: nil
end
