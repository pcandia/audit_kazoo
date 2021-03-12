defmodule API.Registrations do
  alias API.Utils

  @spec list_registrations() :: {:error, any()} | {:ok, any()}
  def list_registrations do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "registrations")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec count_registrations() :: {:error, any()} | {:ok, any()}
  def count_registrations do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "registrations/count")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec delete_registration(String.t()) :: {:error, any()} | {:ok, any()}
  def delete_registration(username_or_devide_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "registrations/#{username_or_devide_id}")
    |> HTTPoison.delete(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec delete_all_registrations() :: {:error, any()} | {:ok, any()}
  def delete_all_registrations do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "registrations")
    |> HTTPoison.delete(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
