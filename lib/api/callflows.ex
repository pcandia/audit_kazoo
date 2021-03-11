defmodule API.Callflows do
  alias API.Utils

  @spec fetch_callflows() :: {:error, any} | {:ok, any}
  def fetch_callflows do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "callflows")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec fetch_callflow(String.t()) :: {:error, any} | {:ok, any}
  def fetch_callflow(callflow_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "callflows/#{callflow_id}")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec create_callflow(%{name: String.t(), numbers: list(), patterns: list()}) ::
          {:error, any} | {:ok, any}
  def create_callflow(data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: data})

    (Utils.build_url_with_account() <> "callflows")
    |> HTTPoison.put(body, header)
    |> case do
      {:ok, %{body: body, status_code: 201}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec delete_callflow(String.t()) :: {:error, any} | {:ok, any}
  def delete_callflow(callflow_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "callflows/#{callflow_id}")
    |> HTTPoison.delete(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec patch_callflow(String.t(), map()) :: {:error, any} | {:ok, any}
  def patch_callflow(callflow_id, data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: data})

    (Utils.build_url_with_account() <> "callflows/#{callflow_id}")
    |> HTTPoison.patch(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec change_callflow(String.t(), %{name: String.t(), numbers: list(), patterns: list()}) ::
          {:error, any} | {:ok, any}
  def change_callflow(callflow_id, data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: data})

    (Utils.build_url_with_account() <> "callflows/#{callflow_id}")
    |> HTTPoison.post(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
