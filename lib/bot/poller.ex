require Logger
require TelegramClient.Wrapper

defmodule Bot.Poller do
  @moduledoc """
  Listens requests to the bot and sends this messages to processing
  """

  use GenServer

  alias TelegramClient.Wrapper, as: TelegramClient

  defmodule State do
    @typedoc """
    Describes Poller process state. Used to store timeout and current offset for messages
    """

    @type t :: %__MODULE__{timeout: integer, offset: integer}

    defstruct timeout: 15, offset: 0
  end
  
  defmodule Message do
    @moduledoc """
    Describes Poller received message from Telegram bot.
    Structure to store required attributes from Nadia Telegram message
    """

    @type t :: %__MODULE__{
      update_id: integer,
      chat_id: integer,
      text: String.t
    }

    defstruct update_id: nil, text: nil, chat_id: nil
  end

  @doc false
  def start_link do
    GenServer.start_link(__MODULE__, [], [name: :pooler_server])
  end

  @doc false
  @spec init([]) :: {:ok, Bot.Poller.State.t}
  def init([]) do
    Logger.log(:info, "Pooling server started...")
    schedule_pool_messages()

    {:ok, %State{}}
  end

  @doc """
  Pool messages from Telegram and send received messages to `ReplyHandler`
  """
  @spec handle_info(:pool_messages, State.t) :: {:noreply, State.t}
  def handle_info(:pool_messages, state = %State{timeout: timeout, offset: offset}) do
    response =
      [offset: offset, timeout: timeout]
      |> TelegramClient.get_updates
      |> process_messages
  
    state = case response do
      %Message{update_id: offset} -> %State{state | offset: offset + 1}
      _ -> state
    end

    schedule_pool_messages()
    {:noreply, state}
  end

  defp process_messages({:ok, messages}) do
    messages
    |> Enum.map(&process_message/1)
    |> List.last
  end

  defp process_messages({:error, _}), do: :error

  defp process_message(%{update_id: update_id, message: %{text: text, chat: %{id: chat_id}}}) do
    message = %Message{update_id: update_id, text: text, chat_id: chat_id}
    Bot.ReplyHandler.handle_message(message)
    message
  end

  defp process_message(_), do: nil

  defp schedule_pool_messages do
    Process.send_after(self(), :pool_messages, 200)
  end
end
