defmodule API.QubicleRecipient do
  alias API.Utils

  @spec list_recipients() :: {:error, any} | {:ok, any}
  def list_recipients do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]

    (Utils.build_url_with_account() <> "qubicle_recipients")
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

    (Utils.build_url_with_account() <> "qubicle_recipients/#{user_id}/status")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec get_recipient_list_status(list()) :: {:error, any} | {:ok, any}
  def get_recipient_list_status(recipient_ids) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: %{recipient_ids: recipient_ids}})

    (Utils.build_url_with_account() <> "qubicle_recipients/status")
    |> HTTPoison.post(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec login_recipient(String.t()) :: {:error, any} | {:ok, any}
  def login_recipient(recipient_id), do: recipient_action(recipient_id, :login)

  @spec logout_recipient(String.t()) :: {:error, any} | {:ok, any}
  def logout_recipient(recipient_id), do: recipient_action(recipient_id, :logout)

  @spec wrapup_extend(String.t()) :: {:error, any} | {:ok, any}
  def wrapup_extend(recipient_id), do: recipient_action(recipient_id, :wrapup_extend)

  @spec wrapup_cancel(String.t()) :: {:error, any} | {:ok, any}
  def wrapup_cancel(recipient_id), do: recipient_action(recipient_id, :wrapup_cancel)

  @spec set_recipient_status(String.t(), :login | :logout | :ready | :away) ::
          {:error, any} | {:ok, any}
  def set_recipient_status(recipient_id, status) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: %{status: status}})

    (Utils.build_url_with_account() <> "qubicle_recipients/#{recipient_id}/status")
    |> HTTPoison.post(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec monitor_recipient(String.t(), :eavesdrop | :whisper | :barge) ::
          {:error, any} | {:ok, any}
  def monitor_recipient(recipient_id, action) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: %{action: :monitor, target: recipient_id, mode: action}})

    (Utils.build_url_with_account() <> "qubicle_recipients/#{recipient_id}")
    |> HTTPoison.post(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  defp recipient_action(recipient_id, action) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: %{action: action}})

    (Utils.build_url_with_account() <> "qubicle_recipients/#{recipient_id}")
    |> HTTPoison.post(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
