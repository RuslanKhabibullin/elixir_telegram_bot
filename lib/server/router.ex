require Telegram.MessageHandler

defmodule Server.Router do
  @moduledoc """
  Simple routing for web-server. Respond only to root url
  """

  use Plug.Router

  plug(:match)
  plug Plug.Parsers, parsers: [:json],
                     pass:  ["application/json"],
                     json_decoder: Poison
  plug(:dispatch)

  get "/" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{text: "Hello from RuslanTestBot :)"}))
  end

  post "/:bot_token" do
    telegram_token = Application.get_env(:nadia, :token)

    case bot_token do
      ^telegram_token ->
        Telegram.MessageHandler.call(conn.body_params)
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Poison.encode!(%{status: true}))
      _ -> send_resp(conn, 404, "Page not found")
    end
  end

  match _ do
    send_resp(conn, 404, "Page not found")
  end
end
