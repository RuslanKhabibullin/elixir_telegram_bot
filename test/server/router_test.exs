defmodule Server.RouterTest do
  use ExUnit.Case
  use Plug.Test

  doctest Server.Router

  alias Server.Router

  @opts Router.init([])

  describe "get /" do
    test "it returns successfull response" do
      conn = conn(:get, "/")
      conn = Router.call(conn, @opts)

      assert conn.status == 200
      assert Poison.Parser.parse(conn.resp_body) == {:ok, %{"text" => "Hello from RuslanTestBot :)"}}
    end
  end

  describe "post /:token" do
    test "it handle telegram message on token match" do
      conn = conn(:post, "/#{Application.get_env(:nadia, :token)}")
      conn = Router.call(conn, @opts)

      assert conn.status == 200
      assert Poison.Parser.parse(conn.resp_body) == {:ok, %{"status" => true}}
    end

    test "it responds with 404 on token mismatch" do
      conn = conn(:post, "/invalid_token")
      conn = Router.call(conn, @opts)

      assert conn.status == 404
    end
  end

  describe "404 response" do
    test "it returns 404 on route mismatch" do
      conn = conn(:get, "/invalid_route")
      conn = Router.call(conn, @opts)

      assert conn.status == 404
    end
  end
end
