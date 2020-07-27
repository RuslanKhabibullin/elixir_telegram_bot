defmodule ServerTest do
  use ExUnit.Case

  doctest Server

  test "runs all applications on app start" do
    Server.start(:normal, [])

    assert is_pid(Process.whereis(:server_supervisor))
  end
end
