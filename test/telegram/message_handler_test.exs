defmodule Telegram.MessageHandlerTest do
  use ExUnit.Case

  doctest Telegram.MessageHandler

  alias Telegram.MessageHandler

  import Mox

  setup :verify_on_exit!

  describe "call/1" do
    test "called with valid arguments and proper message /help" do
      expected_reply_text =
      """
      Usable commands:
      /anime_wallpaper - Get anime wallpaper
      """
      expect(TelegramClientMock, :send_message, fn (0, ^expected_reply_text, []) -> :ok end)
      MessageHandler.call(%{"message" => %{"text" => "/help", "chat" => %{"id" => 0}}})
    end

    test "called with valid arguments and proper message /start" do
      expected_reply_text =
      """
      Hello! This is RuslanTestBot for elixir learning
      Please use `/help` for commands
      """
      expect(TelegramClientMock, :send_message, fn (0, ^expected_reply_text, []) -> :ok end)
      MessageHandler.call(%{"message" => %{"text" => "/start", "chat" => %{"id" => 0}}})
    end

    test "called with valid arguments and proper message /anime_wallpaper" do
      expect(AnimeClientMock, :get_random_image, fn -> %{url: "http://www.internet.com/random_image.jpg"} end)
      expect(TelegramClientMock, :send_photo, fn (0, "http://www.internet.com/random_image.jpg", []) -> :ok end)
      MessageHandler.call(%{"message" => %{"text" => "/anime_wallpaper", "chat" => %{"id" => 0}}})
    end

    test "called with valid arguments and invalid message text" do
      expect(TelegramClientMock, :send_message, 0, fn (_chat_id, _text) -> nil end)
      expect(TelegramClientMock, :send_photo, 0, fn (_chat_id, _image_url) -> nil end)
      MessageHandler.call(%{"message" => %{"text" => "Hello!", "chat" => %{"id" => 0}}})
    end

    test "called with invalid arguments" do
      assert MessageHandler.call(%{}) == nil
    end
  end
end
