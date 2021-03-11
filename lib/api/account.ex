defmodule API.Account do
  alias API.Utils

  @spec user_auth :: {:error, any} | {:ok, any}
  def user_auth do
    header = ["Content-Type": :"application/json"]
    account_name = Application.get_env(:audit_kazoo, :account_name)

    body =
      Poison.encode!(%{
        data: %{
          credentials: generate_credentials_hash(),
          account_name: account_name,
          method: "md5"
        }
      })

    (Utils.build_url() <> "user_auth")
    |> HTTPoison.put(body, header)
    |> case do
      {:ok, %{body: body, status_code: 201}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec about :: {:error, any} | {:ok, any}
  def about do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "about")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec fetch_account_doc :: {:error, any} | {:ok, any}
  def fetch_account_doc do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    Utils.build_url_with_account()
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec create_new_account(any) :: {:error, any} | {:ok, any}
  def create_new_account(name_child_account) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: %{name: name_child_account}})

    (Utils.build_url() <> "accounts")
    |> HTTPoison.put(body, header)
    |> case do
      {:ok, %{body: body, status_code: 201}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec remove_account(any) :: {:error, any} | {:ok, any}
  def remove_account(account_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url() <> "accounts/#{account_id}")
    |> HTTPoison.delete(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  defp generate_credentials_hash do
    username = Application.get_env(:audit_kazoo, :username)
    password = Application.get_env(:audit_kazoo, :password)

    :crypto.hash(:md5, "#{username}:#{password}")
    |> Base.encode16()
    |> String.downcase()
  end
end
