defmodule API.ClickToCall do
  alias API.Utils

  @url Application.get_env(:audit_kazoo, :base_url)
  @account_id Application.get_env(:audit_kazoo, :account_id)

  @spec list_click_to_call_endpoints() :: {:error, any} | {:ok, any}
  def list_click_to_call_endpoints do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    "#{@url}:8000/v2/accounts/#{@account_id}/clicktocall"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec create_click_to_call(%{name: String.t(), auth_required: boolean(), extension: String.t()}) ::
          {:error, any} | {:ok, any}
  def create_click_to_call(%{name: _, auth_required: _, extension: _} = data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: data})

    "#{@url}:8000/v2/accounts/#{@account_id}/clicktocall"
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

    "#{@url}:8000/v2/accounts/#{@account_id}/clicktocall/#{c2c_id}"
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

    "#{@url}:8000/v2/accounts/#{@account_id}/clicktocall/#{c2c_id}"
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

    "#{@url}:8000/v2/accounts/#{@account_id}/clicktocall/#{c2c_id}"
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

    "#{@url}:8000/v2/accounts/#{@account_id}/clicktocall/#{c2c_id}/connect?contact=#{contact}"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
