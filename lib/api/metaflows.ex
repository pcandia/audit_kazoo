defmodule API.Metaflows do
  require Logger

  alias API.Utils

  @type metaflows :: %{
          binding_digit: String.t(),
          digit_timeout: integer(),
          listen_on: String.t(),
          numbers: map(),
          patterns: map()
        }

  @spec fetch_metaflows() :: {:error, any()} | {:ok, any()}
  def fetch_metaflows, do: fetch_metaflows_call("", "")

  @spec fetch_metaflows_for_user(String.t()) :: {:error, any()} | {:ok, any()}
  def fetch_metaflows_for_user(user_id), do: fetch_metaflows_call("users/", user_id <> "/")

  @spec fetch_metaflows_for_device(String.t()) :: {:error, any()} | {:ok, any()}
  def fetch_metaflows_for_device(device_id),
    do: fetch_metaflows_call("devices/", device_id <> "/")

  @spec set_metaflows(metaflows()) :: {:error, any()} | {:ok, any()}
  def set_metaflows(data), do: set_metaflows_call("", "", data)

  @spec set_metaflows_for_user(Strin.t(), metaflows()) :: {:error, any()} | {:ok, any()}
  def set_metaflows_for_user(user_id, data),
    do: set_metaflows_call("users/", user_id <> "/", data)

  @spec set_metaflows_for_device(Strin.t(), metaflows()) :: {:error, any()} | {:ok, any()}
  def set_metaflows_for_device(device_id, data),
    do: set_metaflows_call("devices/", device_id <> "/", data)

  @spec delete_metaflows() :: {:error, any()} | {:ok, any()}
  def delete_metaflows, do: delete_metaflows_call("", "")

  @spec delete_metaflows_for_user(String.t()) :: {:error, any()} | {:ok, any()}
  def delete_metaflows_for_user(user_id), do: delete_metaflows_call("users/", user_id <> "/")

  @spec delete_metaflows_for_device(String.t()) :: {:error, any()} | {:ok, any()}
  def delete_metaflows_for_device(device_id),
    do: delete_metaflows_call("devices/", device_id <> "/")

  defp fetch_metaflows_call(uri_path, user_or_device_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "#{uri_path}" <> "#{user_or_device_id}" <> "metaflows")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} ->
        Utils.decode(body)

      {:error, %{reason: reason}} ->
        {:error, reason}
    end
  end

  defp set_metaflows_call(uri_path, user_or_device_id, data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: data})

    (Utils.build_url_with_account() <> "#{uri_path}" <> "#{user_or_device_id}" <> "metaflows")
    |> HTTPoison.post(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  defp delete_metaflows_call(uri_path, user_or_device_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]

    (Utils.build_url_with_account() <> "#{uri_path}" <> "#{user_or_device_id}" <> "metaflows")
    |> HTTPoison.delete(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
