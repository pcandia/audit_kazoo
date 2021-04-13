defmodule API.Security do
  alias API.Utils

  @spec list_available_auth_module() :: {:error, any()} | {:ok, any()}
  def list_available_auth_module do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url() <> "security")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec fetch_all_configurations() :: {:error, any()} | {:ok, any()}
  def fetch_all_configurations do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "security")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec change_config_for_account(map()) :: {:error, any()} | {:ok, any()}
  def change_config_for_account(%{auth_modules: _} = data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: data})

    (Utils.build_url_with_account() <> "security")
    |> HTTPoison.post(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec patch_config_for_account(map()) :: {:error, any()} | {:ok, any()}
  def patch_config_for_account(%{auth_modules: _} = data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: data})

    (Utils.build_url_with_account() <> "security")
    |> HTTPoison.patch(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec delete_auth_config_for_account() :: {:error, any()} | {:ok, any()}
  def delete_auth_config_for_account do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "security")
    |> HTTPoison.delete(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec list_login_attempts() :: {:error, any()} | {:ok, any()}
  def list_login_attempts do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "security/attempts")
    |> HTTPoison.delete(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec login_attempt_details(String.t()) :: {:error, any()} | {:ok, any()}
  def login_attempt_details(attempt_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "security/attempts/#{attempt_id}")
    |> HTTPoison.delete(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
