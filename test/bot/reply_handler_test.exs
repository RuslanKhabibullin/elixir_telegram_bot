defmodule Bot.ReplyHandlerTest do
  use ExUnit.Case

  doctest Bot.ReplyHandler

  import Mox

  setup :set_mox_global
  setup :verify_on_exit!

  describe "init/1" do
    test "initialized with state" do
      state = %Bot.ReplyHandler.State{}
      assert Bot.ReplyHandler.init([]) == {:ok, state}
    end
  end

  describe "handle_message/1" do
    test "received message that cant be handled" do
      expect(TelegramClientMock, :send_message, 0, fn (_chat_id, _text) -> nil end)
      expect(TelegramClientMock, :send_photo, 0, fn (_chat_id, _image) -> nil end)

      message = %Bot.Poller.Message{update_id: 0, chat_id: 0, text: "Hello"}
      Bot.ReplyHandler.handle_cast(message, %Bot.ReplyHandler.State{})
    end

    test "received message /start" do
      expected_reply_text =
      """
      Hello! This is RuslanTestBot for elixir learning
      Please use `/help` for commands
      """

      expect(TelegramClientMock, :send_message, fn (0, ^expected_reply_text, []) -> :ok end)

      message = %Bot.Poller.Message{update_id: 0, chat_id: 0, text: "/start"}
      Bot.ReplyHandler.handle_cast(message, %Bot.ReplyHandler.State{})
    end

    test "received message /help" do
      expected_reply_text =
      """
      Usable commands:
      /anime_wallpaper - Get anime wallpaper
      """

      expect(TelegramClientMock, :send_message, fn (0, ^expected_reply_text, []) -> :ok end)

      message = %Bot.Poller.Message{update_id: 0, chat_id: 0, text: "/help"}
      Bot.ReplyHandler.handle_cast(message, %Bot.ReplyHandler.State{})
    end

    test "received message /anime_wallpaper" do
      expect(AnimeClientMock, :get_random_image, fn -> %{url: "http://www.internet.com/random_image.jpg"} end)
      expect(TelegramClientMock, :send_photo, fn (0, "http://www.internet.com/random_image.jpg", []) -> :ok end)

      message = %Bot.Poller.Message{update_id: 0, chat_id: 0, text: "/anime_wallpaper"}
      Bot.ReplyHandler.handle_cast(message, %Bot.ReplyHandler.State{})
    end
  end
end
