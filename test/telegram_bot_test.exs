defmodule TelegramBotTest do
  use ExUnit.Case

  doctest TelegramBot

  import Mox

  setup :set_mox_global
  setup :verify_on_exit!
  setup do
    stub(TelegramClientMock, :get_updates, fn _options -> {:ok, []} end)
    TelegramBot.start(:normal, [])

    :ok
  end

  test "runs all applications on app start" do
    Enum.each [:bot_supervisor, :server_supervisor], fn (process_name) ->
      assert is_pid(Process.whereis(process_name))
    end
  end
end
