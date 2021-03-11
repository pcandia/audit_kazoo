defmodule API.QubicleQueue do
  alias API.Utils

  @type qubicle_queue :: %{
          name: String.t(),
          queue_type: String.t(),
          agent_wrapup_time: integer(),
          force_away_on_reject: boolean(),
          hold_treatment: String.t(),
          queue_router: String.t(),
          timeout_redirect: String.t(),
          timeout_immediately_if_empty: boolean(),
          timeout_if_size_exceeds: integer(),
          ring_timeout: integer(),
          tick_time: integer(),
          timeout: integer()
        }

  @spec list_queues :: {:error, any} | {:ok, any}
  def list_queues do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]

    (Utils.build_url_with_account() <> "qubicle_queues")
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

    (Utils.build_url_with_account() <> "qubicle_queues/status")
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

    (Utils.build_url_with_account() <> "qubicle_queues/#{queue_id}")
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

    (Utils.build_url_with_account() <> "qubicle_queues/#{queue_id}/status")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec create_queue(qubicle_queue()) :: {:error, any} | {:ok, any}
  def create_queue(%{name: _} = data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: data})

    (Utils.build_url_with_account() <> "qubicle_queues")
    |> HTTPoison.put(body, header)
    |> case do
      {:ok, %{body: body, status_code: 201}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec modify_queue(String.t(), qubicle_queue()) :: {:error, any} | {:ok, any}
  def modify_queue(queue_id, queue_data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: queue_data})

    (Utils.build_url_with_account() <> "qubicle_queues/#{queue_id}")
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

    (Utils.build_url_with_account() <> "qubicle_queues/#{queue_id}/sessions")
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

    (Utils.build_url_with_account() <> "qubicle_queues/#{queue_id}/recipients")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec set_queue_membership(String.t(), %{action: any, members: any}) ::
          {:error, any} | {:ok, any}
  def set_queue_membership(queue_id, %{action: _action, members: _members} = membership) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: membership})

    (Utils.build_url_with_account() <> "qubicle_queues/#{queue_id}/recipients")
    |> HTTPoison.post(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec delete_membership(String.t()) :: {:error, any} | {:ok, any}
  def delete_membership(queue_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]

    (Utils.build_url_with_account() <> "qubicle_queues/#{queue_id}/recipients")
    |> HTTPoison.delete(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
