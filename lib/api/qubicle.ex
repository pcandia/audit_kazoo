defmodule API.Qubicle do
  alias API.Utils

  @url Application.get_env(:audit_kazoo, :base_url)
  @account_id Application.get_env(:audit_kazoo, :account_id)

  @spec list_queues :: {:error, any} | {:ok, any}
  def list_queues do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]

    "#{@url}:8000/v2/accounts/#{@account_id}/qubicle_queues"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec queue_list_status :: {:error, any} | {:ok, any}
  def queue_list_status do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]

    "#{@url}:8000/v2/accounts/#{@account_id}/qubicle_queues/status"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec get_queue_info(String.t()) :: {:error, any} | {:ok, any}
  def get_queue_info(queue_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]

    "#{@url}:8000/v2/accounts/#{@account_id}/qubicle_queues/#{queue_id}"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec get_queue_status(String.t()) :: {:error, any} | {:ok, any}
  def get_queue_status(queue_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]

    "#{@url}:8000/v2/accounts/#{@account_id}/qubicle_queues/#{queue_id}/status"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec create_queue(String.t()) :: {:error, any} | {:ok, any}
  def create_queue(queue_name) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: %{name: queue_name}})

    "#{@url}:8000/v2/accounts/#{@account_id}/qubicle_queues"
    |> HTTPoison.put(body, header)
    |> case do
      {:ok, %{body: body, status_code: 201}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec modify_queue(String.t(), map()) :: {:error, any} | {:ok, any}
  def modify_queue(queue_id, queue_data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: queue_data})

    "#{@url}:8000/v2/accounts/#{@account_id}/qubicle_queues/#{queue_id}"
    |> HTTPoison.patch(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec list_queue_sessions(String.t()) :: {:error, any} | {:ok, any}
  def list_queue_sessions(queue_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    "#{@url}:8000/v2/accounts/#{@account_id}/qubicle_queues/#{queue_id}/sessions"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec list_queue_recipients(String.t()) :: {:error, any} | {:ok, any}
  def list_queue_recipients(queue_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    "#{@url}:8000/v2/accounts/#{@account_id}/qubicle_queues/#{queue_id}/recipients"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
