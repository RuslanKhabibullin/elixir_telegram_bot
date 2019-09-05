require Logger
require Anime.Client
require Telegram.Client

defmodule Bot.ReplyHandler do
  @moduledoc """
  Reply logic for received messages from Telegram
  """

  use GenServer

  @start_message """
                 Hello! This is RuslanTestBot for elixir learning
                 Please use `/help` for commands
                 """
  @help_message """
                Usable commands:
                /anime_wallpaper - Get anime wallpaper
                """

  defmodule State do
    @typedoc """
    Describes ReplyHandler process state.
    Usually store only state with :ok attribute.
    """

    @type t :: %__MODULE__{state: atom}

    defstruct state: :ok
  end

  @doc false
  def start_link do
    GenServer.start_link(__MODULE__, [], name: :reply_handler)
  end

  @doc false
  @spec init([]) :: {:ok, State.t}
  def init([]) do
    Logger.log(:info, "Reply server started...")
    {:ok, %State{}}
  end

  @doc """
  Respond logic for received message from telegram
  """
  @spec handle_cast(Bot.Poller.Message.t, State.t) :: {:noreply, State.t}
  def handle_cast(%Bot.Poller.Message{chat_id: chat_id, text: text}, state = %State{}) do
    case text do
      "/start" -> Telegram.Client.send_message(chat_id, @start_message)
      "/help" -> Telegram.Client.send_message(chat_id, @help_message)
      "/anime_wallpaper" -> Telegram.Client.send_photo(chat_id, Anime.Client.get_random_image.url)
      _ -> nil
    end
    {:noreply, state}
  end

  @doc """
  Interface for message reply handler call
  """
  @spec handle_message(Bot.Poller.Message.t) :: :ok
  def handle_message(message = %Bot.Poller.Message{}) do
    GenServer.cast(:reply_handler, message)
  end
end
