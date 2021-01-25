defmodule AuditKazoo.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/audit" do
    send_resp(conn, 200, "Hello Elixir Plug!")
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
