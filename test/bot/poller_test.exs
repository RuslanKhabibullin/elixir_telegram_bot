defmodule Bot.PollerTest do
  use ExUnit.Case

  doctest Bot.Poller

  import Mox

  describe "init/1" do
    test "initialized with state" do
      state = %Bot.Poller.State{timeout: 15, offset: 0}
      assert Bot.Poller.init([]) == {:ok, state}
      assert_receive :pool_messages, 300
    end
  end
end
