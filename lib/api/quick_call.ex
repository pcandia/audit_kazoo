defmodule API.QuickCall do
  alias API.Utils

  @spec call_device(String.t(), String.t()) :: {:error, any} | {:ok, any}
  def call_device(device_id, phone_number) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "devices/#{device_id}/quickcall/#{phone_number}")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec call_user(String.t(), String.t()) :: {:error, any} | {:ok, any}
  def call_user(user_id, phone_number) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "users/#{user_id}/quickcall/#{phone_number}")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
