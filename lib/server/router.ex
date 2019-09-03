defmodule Server.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{ text: "Hello from RuslanTestBot :)"}))
  end

  match _ do
    send_resp(conn, 404, "Page not found")
  end
end