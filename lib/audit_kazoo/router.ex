defmodule AuditKazoo.Router do
  use Plug.Router
  use Plug.Debugger, otp_app: :audit_kazoo

  require EEx

  plug Plug.Static, at: "/dist", from: "libwebphone/dist/"
  plug(:match)
  plug(:dispatch)

  @url Application.get_env(:audit_kazoo, :base_url)
  @sip_caller_username Application.get_env(:audit_kazoo, :sip_caller_username)
  @sip_caller_password Application.get_env(:audit_kazoo, :sip_caller_password)
  @sip_callee_username Application.get_env(:audit_kazoo, :sip_callee_username)
  @sip_callee_password Application.get_env(:audit_kazoo, :sip_callee_password)
  @realm Application.get_env(:audit_kazoo, :realm, "realm.com")

  get "" do
    localhost_ip =
      conn.remote_ip
      |> :inet_parse.ntoa()
      |> to_string()

    Application.put_env(:audit_kazoo, :webhook_uri, localhost_ip)
    page_contents = EEx.eval_file("libwebphone/redphone.eex", [base_url: @url, sip_username: @sip_caller_username, sip_password: @sip_caller_password, realm: @realm])
    conn = Plug.Conn.put_resp_content_type(conn, "text/html")
    send_resp(conn, 200, page_contents)
  end

  get "/telephone" do
    page_contents = EEx.eval_file("libwebphone/telephone.eex", [base_url: @url, sip_username: @sip_callee_username, sip_password: @sip_callee_password, realm: @realm])
    conn = Plug.Conn.put_resp_content_type(conn, "text/html")
    send_resp(conn, 200, page_contents)
  end

  post "/events" do
    headers = conn.req_headers
    {:ok, body, conn} = Plug.Conn.read_body(conn, opts)
    format = :proplists.get_value("content-type", headers)
    {:ok, event} = decode_body(format, body)
    :ok = AuditKazoo.Server.add_event(event)
    send_resp(conn, 200, "ok")
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end

  defp decode_body("application/json", body), do: Poison.decode(body, keys: :atoms)

  defp decode_body("form-data", body) do
    URI.query_decoder(body)
    |> Enum.map(& &1)
    |> Enum.into(%{})
  end
end
