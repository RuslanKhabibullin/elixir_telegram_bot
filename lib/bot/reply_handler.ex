require Logger
require Anime.Wallpaper

defmodule Bot.ReplyHandler do
  use GenServer

  defmodule State do
    defstruct state: :ok
  end

  def start_link do
    GenServer.start_link(__MODULE__, [], [name: :reply_handler])
  end

  def init([]) do
    Logger.log(:info, "Reply server started...")
    {:ok, %State{}}
  end

  def handle_cast(%Bot.Poller.Message{chat_id: chat_id, text: text}, state = %State{}) do
    handle_message(chat_id, text)
    {:noreply, state}
  end

  defp handle_message(chat_id, "/start") do
    message =
      """
      Hello! This is RuslanTestBot for elixir learning
      Please use `/help` for commands
      """

    Nadia.send_message(chat_id, message)
  end

  defp handle_message(chat_id, "/help") do
    message =
      """
      Usable commands:
      /anime_wallpaper - Get anime wallpaper
      """

    Nadia.send_message(chat_id, message)
  end

  defp handle_message(chat_id, "/anime_wallpaper") do
    Nadia.send_photo(chat_id, Anime.Wallpaper.get_random_image.url)
  end

  defp handle_message(chat_id, _) do
    Nadia.send_message(chat_id, "Command not found. Please use `/help` for command list")
  end
end
