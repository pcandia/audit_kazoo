defmodule API.QubicleRecipient do
  alias API.Utils

  @url Application.get_env(:audit_kazoo, :base_url)
  @account_id Application.get_env(:audit_kazoo, :account_id)

  @spec list_recipients() :: {:error, any} | {:ok, any}
  def list_recipients do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]

    "#{@url}:8000/v2/accounts/#{@account_id}/qubicle_recipients"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec get_recipient_status(String.t()) :: {:error, any} | {:ok, any}
  def get_recipient_status(user_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]

    "#{@url}:8000/v2/accounts/#{@account_id}/qubicle_recipients/#{user_id}/status"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
