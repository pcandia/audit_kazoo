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
end
