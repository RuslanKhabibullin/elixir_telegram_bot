defmodule Mix.Tasks.TelegramBotTest do
  use ExUnit.Case

  doctest Mix.Tasks.TelegramBot

  import Mox

  setup :set_mox_global

  test "runs all applications on app start" do
    stub(TelegramClientMock, :get_updates, fn _options -> {:ok, []} end)
    Mix.Tasks.TelegramBot.run(:normal)

    assert is_pid(Process.whereis(:bot_supervisor))
  end
end
