require Logger

defmodule Bot.Poller do
  use GenServer

  @moduledoc """
  Listens requests to the bot and sends this messages to processing
  """

  defmodule State do
    @moduledoc """
    Describes Poller process state. Used to store timeout and current offset for messages
    """

    @type t :: %__MODULE__{
      timeout: integer,
      offset: integer
    }

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
    state = %State{}
    Logger.log(:info, "Pooling server started...")

    spawn fn -> handle_cast(:start_pool, state) end
    {:ok, state}
  end

  @doc """
  Invoked on process initialize - starts infinite loop for Telegram message parsing
  """
  @spec handle_cast(any, Bot.Poller.State.t()) :: {:noreply, Bot.Poller.State.t()}
  def handle_cast(_msg, state = %State{}) do
    pool(state)
    {:noreply, state}
  end

  defp pool(state = %State{timeout: timeout, offset: offset}) do
    response =
      [offset: offset, timeout: timeout]
      |> Nadia.get_updates
      |> process_messages

    case response do
      %Message{update_id: offset} -> pool(%State{state | offset: offset + 1})
      _ -> pool(state)
    end
  end

  defp process_messages({:ok, messages}) do
    messages
    |> Enum.map(&process_message/1)
    |> List.last
  end

  defp process_messages({:error, _}), do: :error

  defp process_message(%{update_id: update_id, message: %{text: text, chat: %{id: chat_id}}}) do
    message = %Message{update_id: update_id, text: text, chat_id: chat_id}
    GenServer.cast(:reply_handler, message)
    message
  end
end
