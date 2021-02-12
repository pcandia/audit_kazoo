defmodule AuditKazoo.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "" do
    localhost_ip =
      conn.remote_ip
      |> :inet_parse.ntoa()
      |> to_string()

    Application.put_env(:audit_kazoo, :webhook_uri, localhost_ip)
    send_resp(conn, 200, "Hello!")
  end

  post "/events" do
    send_resp(conn, 200, "ok")
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
