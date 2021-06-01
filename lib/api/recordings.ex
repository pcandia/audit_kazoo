defmodule API.Recordings do
  alias API.Utils

  @spec fetch_recordings() :: {:error, any} | {:ok, any}
  def fetch_recordings do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "recordings")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec fetch_recording(String.t()) :: {:error, any} | {:ok, any}
  def fetch_recording(recording_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Accept": :"audio/mpeg"]

    (Utils.build_url_with_account() <> "recordings/#{recording_id}")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec delete_recording(String.t()) :: {:error, any} | {:ok, any}
  def delete_recording(recording_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]

    (Utils.build_url_with_account() <> "recordings/#{recording_id}")
    |> HTTPoison.delete(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
