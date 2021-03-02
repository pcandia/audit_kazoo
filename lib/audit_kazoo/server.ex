defmodule AuditKazoo.Server do
  use GenServer

  alias API.Utils
  @pvt_token_timer 1_740_000

  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @spec get_events() :: list()
  def get_events do
    GenServer.call(__MODULE__, :get_events)
  end

  @spec filter_event_by_kv(atom(), String.t()) :: list()
  def filter_event_by_kv(key, value) do
    Enum.filter(get_events(), fn element -> Map.get(element, key) end)
    |> Enum.filter(fn event -> match?(%{^key => ^value}, event) end)
  end

  @spec add_event(map()) :: :ok
  def add_event(event_body) do
    GenServer.cast(__MODULE__, {:add_event, event_body})
  end

  @impl true
  def init(args) do
    schedule_auth_token()
    {:ok, args}
  end

  @impl true
  def handle_call(:get_events, _, state), do: {:reply, state, state}

  @impl true
  def handle_cast({:add_event, event}, state) do
    new_state =
      case Enum.member?(state, event) do
        true -> state
        false -> [event | state]
      end

    {:noreply, new_state}
  end

  @impl true
  def handle_info(:set_auth_token, state) do
    schedule_auth_token()
    {:noreply, state}
  end

  defp schedule_auth_token do
    Utils.set_auth_token()
    Process.send_after(self(), :set_auth_token, @pvt_token_timer)
  end
end
