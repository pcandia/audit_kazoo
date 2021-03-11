defmodule API.Utils do
  require Logger

  alias API.Account

  @spec set_auth_token :: :ok
  def set_auth_token do
    case Account.user_auth() do
      {:error, reason} ->
        Logger.error("Could not retrieve the user token, reason: #{reason}")

      {:ok, body_response} ->
        Application.put_env(:audit_kazoo, :auth_token, Map.get(body_response, :auth_token))
    end
  end

  @spec get_auth_token :: String.t()
  def get_auth_token, do: Application.get_env(:audit_kazoo, :auth_token)

  @spec decode(any()) :: {:ok, any()} | {:error, any()}
  def decode(body), do: Poison.decode(body, keys: :atoms)

  @spec build_url() :: String.t()
  def build_url do
    protocol =
      Application.get_env(:audit_kazoo, :protocol)
      |> Atom.to_string()

    uri = Application.get_env(:audit_kazoo, :base_url)

    "#{protocol}://#{uri}:8000/v2/"
  end

  @spec build_url_with_account() :: String.t()
  def build_url_with_account do
    account_id = Application.get_env(:audit_kazoo, :account_id)
    build_url() <> "accounts/#{account_id}/"
  end
end
