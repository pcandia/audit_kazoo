defmodule API.Webhooks do
  alias API.Utils

  @url Application.get_env(:audit_kazoo, :base_url)
  @account_id Application.get_env(:audit_kazoo, :account_id)

  @type webhook :: %{
          name: String.t(),
          uri: String.t(),
          hook: String.t(),
          format: String.t(),
          enabled: boolean(),
          http_verb: String.t(),
          retries: integer(),
          include_subaccounts: map(),
          include_internal_legs: map(),
          custom_data: map()
        }

  @spec fetch_webhooks() :: {:error, any} | {:ok, any}
  def fetch_webhooks do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]

    "#{@url}:8000/v2/webhooks"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec list_webhooks() :: {:error, any} | {:ok, any}
  def list_webhooks() do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    "#{@url}:8000/v2/accounts/#{@account_id}/webhooks"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec create_webhook(webhook()) :: {:error, any} | {:ok, any}
  def create_webhook(%{name: _, uri: _, hook: _} = data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: data})

    "#{@url}:8000/v2/accounts/#{@account_id}/webhooks"
    |> HTTPoison.put(body, header)
    |> case do
      {:ok, %{body: body, status_code: 201}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec edit_webhook(String.t(), webhook()) :: {:error, any} | {:ok, any}
  def edit_webhook(webhook_id, %{name: _, uri: _, hook: _} = data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: data})

    "#{@url}:8000/v2/accounts/webhooks/#{webhook_id}"
    |> HTTPoison.post(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec get_webhook(String.t()) :: {:error, any} | {:ok, any}
  def get_webhook(webhook_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    "#{@url}:8000/v2/accounts/webhooks/#{webhook_id}"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec patch_webhook(String.t(), true | false) :: {:error, any} | {:ok, any}
  def patch_webhook(webhook_id, action) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: %{enabled: action}})

    "#{@url}:8000/v2/accounts/#{@account_id}/webhooks/#{webhook_id}"
    |> HTTPoison.patch(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec delete_webhook(String.t()) :: {:error, any} | {:ok, any}
  def delete_webhook(webhook_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    "#{@url}:8000/v2/accounts/#{@account_id}/webhooks/#{webhook_id}"
    |> HTTPoison.delete(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
