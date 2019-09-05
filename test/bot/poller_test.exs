defmodule Bot.PollerTest do
  use ExUnit.Case

  doctest Bot.Poller

  import Mox
  import ExUnit.CaptureLog
  import Injex.Test

  setup :set_mox_global

  describe "init/1" do
    test "initialized with state" do
      state = %Bot.Poller.State{timeout: 15, offset: 0}
      assert Bot.Poller.init([]) == {:ok, state}
      assert_receive :pool_messages, 300
    end
  end

  describe "handle_info/2" do
    # Mock for ReplyHandler that signals that message is received
    defmodule ReplyHandlerMock do
      def handle_message(%Bot.Poller.Message{}) do
        send(self(), :reply_handler_received)
      end
    end

    test "dont change state on empty message receive" do
      stub(TelegramClientMock, :get_updates, fn _options -> {:ok, []} end)
      state = %Bot.Poller.State{timeout: 15, offset: 0}

      assert Bot.Poller.handle_info(:pool_messages, state) == {:noreply, state}
      assert_receive :pool_messages, 300
    end

    test "change state on proper message receive" do
      stub TelegramClientMock, :get_updates, fn _options ->
        {:ok, [%{update_id: 0, message: %{text: "Test", chat: %{id: 0}}}]}
      end
      state = %Bot.Poller.State{timeout: 15, offset: 0}

      assert Bot.Poller.handle_info(:pool_messages, state) == {:noreply, %Bot.Poller.State{offset: 1}}
      assert_receive :pool_messages, 300
    end

    test "ReplyHandler called on proper message received" do
      override Bot.Poller, reply_handler: ReplyHandlerMock do
        stub TelegramClientMock, :get_updates, fn _options ->
          {:ok, [%{update_id: 0, message: %{text: "Test", chat: %{id: 0}}}]}
        end

        Bot.Poller.handle_info(:pool_messages, %Bot.Poller.State{})
        # Check that our mock receive message
        assert_receive :reply_handler_received, 300
      end
    end
  end
end
