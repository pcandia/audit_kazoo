defmodule AuditKazoo.WebsocketClient do
  use WebSockex

  require Logger

  alias API.Utils

  def start_link(state \\ [], blackhole_port \\ "5555") do
    protocol =
      Application.get_env(:audit_kazoo, :protocol)
      |> Atom.to_string()

    uri = protocol <> "://" <> Application.get_env(:audit_kazoo, :base_url)
    WebSockex.start_link("#{uri}:#{blackhole_port}", __MODULE__, state, extra_headers: [])
  end

  @spec subscribe(pid(), String.t() | list()) :: :ok
  def subscribe(pid, binding) when is_bitstring(binding), do: subscribe(pid, [binding])

  def subscribe(pid, bindings) when is_list(bindings) do
    auth_token = Utils.get_auth_token()
    account_id = Application.get_env(:audit_kazoo, :account_id)

    message =
      Poison.encode!(%{
        action: "subscribe",
        auth_token: auth_token,
        data: %{account_id: account_id, bindings: [bindings]}
      })

    Logger.info("Subscribing to #{bindings}")
    WebSockex.send_frame(pid, {:text, message})
  end

  @spec unsubscribe(pid(), String.t() | list()) :: :ok
  def unsubscribe(pid, binding) when is_bitstring(binding), do: unsubscribe(pid, [binding])

  def unsubscribe(pid, bindings) when is_list(bindings) do
    auth_token = Utils.get_auth_token()

    message =
      Poison.encode!(%{action: "unsubscribe", auth_token: auth_token, data: %{bindings: bindings}})

    Logger.info("Unbindings to: #{message}")
    WebSockex.send_frame(pid, {:text, message})
  end

  def handle_frame({_type, msg}, state) do
    event =
      case Poison.decode(msg) do
        {:error, error} ->
          Logger.debug(inspect(msg))
          Logger.error(inspect(error))

        {:ok, message} ->
          message |> IO.inspect()
          message
      end

    {:ok, [event | state]}
  end

  def handle_cast({:send, {type, msg} = frame}, state) do
    Logger.info("Sending #{type} frame with payload: #{msg}")
    {:reply, frame, state}
  end

  def handle_disconnect(%{reason: {:local, reason}}, state) do
    Logger.info("Local close with reason: #{inspect(reason)}")
    {:ok, state}
  end

  def handle_disconnect(disconnect_map, state) do
    super(disconnect_map, state)
  end
end
