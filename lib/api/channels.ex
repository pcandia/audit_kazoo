defmodule API.Channels do
  alias API.Utils

  @account_id Application.get_env(:audit_kazoo, :account_id)

  @spec fetch_channels() :: {:error, any} | {:ok, any}
  def fetch_channels do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]

    (Utils.build_url() <> "channels")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:ok, %{status_code: 500}} -> {:ok, "There are no active channels"}
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec fetch_channels_by_account(String.t()) :: {:error, any} | {:ok, any}
  def fetch_channels_by_account(account_id \\ @account_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]

    (Utils.build_url() <> "accounts/#{account_id}/channels")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec fetch_channels_by_user(String.t()) :: {:error, any} | {:ok, any}
  def fetch_channels_by_user(user_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]

    (Utils.build_url_with_account() <> "users/#{user_id}/channels")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec fetch_channels_by_device(String.t()) :: {:error, any} | {:ok, any}
  def fetch_channels_by_device(device_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]

    (Utils.build_url_with_account() <> "devices/#{device_id}/channels")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec fetch_channel(String.t()) :: {:error, any} | {:ok, any}
  def fetch_channel(channel_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]

    (Utils.build_url_with_account() <> "channels/#{channel_id}")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
