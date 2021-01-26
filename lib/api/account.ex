defmodule API.Account do

  @url Application.get_env(:audit_kazoo, :base_url)
  @auth_token Application.get_env(:audit_kazoo, :auth_token)
  @account_id Application.get_env(:audit_kazoo, :account_id)

  @spec about :: {:error, any} | {:ok, any}
  def about do
    header = ["X-Auth-Token": @auth_token]
    "#{@url}:8000/v2/accounts/#{@account_id}/about"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec fetch_account_doc :: {:error, any} | {:ok, any}
  def fetch_account_doc do
    header = ["X-Auth-Token": @auth_token]
    "#{@url}:8000/v2/accounts/#{@account_id}"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec create_new_account(any) :: {:error, any} | {:ok, any}
  def create_new_account(name_child_account) do
    header = ["X-Auth-Token": @auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: %{name: name_child_account}})
    "#{@url}:8000/v2/accounts"
    |> HTTPoison.put(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  defp decode(body), do: Poison.decode(body, keys: :atoms)
end
