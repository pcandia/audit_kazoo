defmodule API.ClickToCall do
  alias API.Utils

  @type click_to_call :: %{
          name: String.t(),
          extension: String.t(),
          auth_required: boolean(),
          caller_id_number: String.t(),
          custom_application_vars: map(),
          dial_first: String.t(),
          media: map(),
          music_on_hold: map(),
          outbound_callee_id_name: String.t(),
          outbound_callee_id_number: String.t(),
          presence_id: String.t(),
          ringback: String.t(),
          throttle: integer(),
          whitelist: list()
        }

  @spec list_click_to_call_endpoints() :: {:error, any} | {:ok, any}
  def list_click_to_call_endpoints do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "clicktocall")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec create_click_to_call(click_to_call()) ::
          {:error, any} | {:ok, any}
  def create_click_to_call(%{name: _, extension: _} = data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: data})

    (Utils.build_url_with_account() <> "clicktocall")
    |> HTTPoison.put(body, header)
    |> case do
      {:ok, %{body: body, status_code: 201}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec fetch_click_to_call(String.t()) :: {:error, any} | {:ok, any}
  def fetch_click_to_call(c2c_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "clicktocall/#{c2c_id}")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec update_click_to_call(String.t(), %{
          name: String.t(),
          auth_required: boolean(),
          extension: String.t()
        }) :: {:error, any} | {:ok, any}
  def update_click_to_call(c2c_id, %{name: _, auth_required: _, extension: _} = data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: data})

    (Utils.build_url_with_account() <> "clicktocall/#{c2c_id}")
    |> HTTPoison.post(body, header)
    |> case do
      {:ok, %{body: body, status_code: 201}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec delete_click_to_call(String.t()) :: {:error, any} | {:ok, any()}
  def delete_click_to_call(c2c_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]

    (Utils.build_url_with_account() <> "clicktocall/#{c2c_id}")
    |> HTTPoison.delete(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec exec_click_to_call(String.t(), String.t()) :: {:error, any} | {:ok, any()}
  def exec_click_to_call(c2c_id, contact) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "clicktocall/#{c2c_id}/connect?contact=#{contact}")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
