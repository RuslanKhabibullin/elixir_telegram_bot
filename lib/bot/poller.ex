require Logger

defmodule Bot.Poller do
  use GenServer

  defmodule State do
    defstruct timeout: 15, offset: 0
  end
  
  defmodule Message do
    defstruct update_id: nil, text: nil, chat_id: nil
  end

  def start_link do
    GenServer.start_link(__MODULE__, [], [name: :pooler_server])
  end

  def init([]) do
    state = %State{}
    Logger.log(:info, "Pooling server started...")

    spawn fn -> handle_cast(:start_pool, state) end
    {:ok, state}
  end

  def handle_cast(_msg, state = %State{}) do
    pool(state)
    {:noreply, state}
  end

  # Pool new messages from telegram over and over again
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

  # Reply to all received messages
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
