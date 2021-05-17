defmodule AuditKazoo.Router do
  import Plug.Conn
  use Plug.Router
  use Plug.Debugger, otp_app: :audit_kazoo

  require EEx

  alias API.Utils

  plug(Plug.Static, at: "/dist", from: "libwebphone/dist/")
  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  @url Application.get_env(:audit_kazoo, :base_url)
  @realm Application.get_env(:audit_kazoo, :realm, "realm.com")

  get "/" do
    localhost_ip =
      conn.remote_ip
      |> :inet_parse.ntoa()
      |> to_string()

    Application.put_env(:audit_kazoo, :webhook_uri, localhost_ip)
    send_resp(conn, 200, "ok")
  end

  get "/softphone" do
    page_contents = load_page_contents()
    conn = Plug.Conn.put_resp_content_type(conn, "text/html")
    send_resp(conn, 200, page_contents)
  end

  get "/softphone/:user" do
    %{username: username, password: password} = maybe_get_user_creds(user)
    page_contents = load_page_contents(username, password)
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

  defp load_page_contents(username \\ "SIP_USERNAME", password \\ "SIP_PASSWORD") do
    EEx.eval_file("lib/audit_kazoo/templates/softphone.html.eex",
      base_url: @url,
      realm: @realm,
      username: username,
      password: password,
      uuid: UUID.uuid1()
    )
  end

  defp maybe_get_user_creds(<<"user_", _::binary>> = user_id) do
    case Utils.get_devices_creds_by_username(user_id) do
      :not_found -> maybe_get_user_creds("")
      user_creds -> user_creds
    end
  end

  defp maybe_get_user_creds(_), do: %{username: "", password: ""}

  defp decode_body("application/json", body), do: Poison.decode(body, keys: :atoms)

  defp decode_body("form-data", body) do
    URI.query_decoder(body)
    |> Enum.map(& &1)
    |> Enum.into(%{})
  end
end
