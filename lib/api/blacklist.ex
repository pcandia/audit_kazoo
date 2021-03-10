defmodule API.Blacklist do
  alias API.Utils

  @url Application.get_env(:audit_kazoo, :base_url)
  @account_id Application.get_env(:audit_kazoo, :account_id)

  @type blacklist :: %{
          name: String.t(),
          numbers: map(),
          should_block_anonymous: boolean()
        }

  @spec fetch_blacklists() :: {:error, any()} | {:ok, any()}
  def fetch_blacklists do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    "#{@url}:8000/v2/accounts/#{@account_id}/blacklists"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec fetch_blacklist(String.t()) :: {:error, any()} | {:ok, any()}
  def fetch_blacklist(blacklist_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    "#{@url}:8000/v2/accounts/#{@account_id}/blacklists/#{blacklist_id}"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec create_blacklist(blacklist()) :: {:error, any()} | {:ok, any()}
  def create_blacklist(%{name: _} = data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: data})

    "#{@url}:8000/v2/accounts/#{@account_id}/blacklists"
    |> HTTPoison.put(body, header)
    |> case do
      {:ok, %{body: body, status_code: 201}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec update_backlist(String.t(), blacklist()) :: {:error, any()} | {:ok, any()}
  def update_backlist(blacklist_id, %{name: _} = data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: data})

    "#{@url}:8000/v2/accounts/#{@account_id}/blacklists/#{blacklist_id}"
    |> HTTPoison.post(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec delete_backlist(String.t()) :: {:error, any()} | {:ok, any()}
  def delete_backlist(blacklist_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    "#{@url}:8000/v2/accounts/#{@account_id}/blacklists/#{blacklist_id}"
    |> HTTPoison.delete(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec patch_backlist(String.t(), blacklist()) :: {:error, any()} | {:ok, any()}
  def patch_backlist(blacklist_id, data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: data})

    "#{@url}:8000/v2/accounts/#{@account_id}/blacklists/#{blacklist_id}"
    |> HTTPoison.patch(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
