defmodule Bot.SupervisorTest do
  use ExUnit.Case
  doctest Bot.Supervisor

  import Mox

  setup :set_mox_global
  setup :verify_on_exit!
  setup do
    stub(TelegramClientMock, :get_updates, fn _options -> {:ok, []} end)
    TelegramBot.start(:normal, [])

    :ok
  end

  test "it successfully restarts failed processes" do
    Enum.each [:pooler_server, :reply_handler], fn (process_name) ->
      pid = Process.whereis(process_name)
      ref = Process.monitor(pid)
      Process.exit(pid, :shutdown)

      receive do
        {:DOWN, ^ref, :process, ^pid, :shutdown} ->
          :timer.sleep(1)
          assert is_pid(Process.whereis(process_name))
        after
          1000 -> raise "Timeout"
      end
    end
  end
end
