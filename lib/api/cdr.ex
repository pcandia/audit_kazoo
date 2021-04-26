defmodule API.Cdr do
  alias API.Utils

  @spec fetch_cdr() :: {:error, any} | {:ok, any}
  def fetch_cdr, do: fetch_cdrs_in_range("", "", "")

  @spec fetch_cdrs_in_range(String.t(), String.t(), String.t()) :: {:error, any} | {:ok, any}
  def fetch_cdrs_in_range(from_timestamp, to_timestamp, timezone \\ "") do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    url =
      case {from_timestamp, to_timestamp, timezone} do
        {"", "", ""} ->
          "cdrs"

        {_, _, ""} ->
          "cdrs?created_from=#{from_timestamp}&created_to=#{to_timestamp}"

        {_, _, _} ->
          "cdrs?created_from=#{from_timestamp}&created_to=#{to_timestamp}&utc_offset={timezone}"
      end

    (Utils.build_url_with_account() <> url)
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec fetch_as_csv() :: {:error, any} | {:ok, any}
  def fetch_as_csv, do: fetch_cdr_as_csv("cdrs")

  @spec fetch_as_csv_filename(String.t()) :: {:error, any} | {:ok, any}
  def fetch_as_csv_filename(filename), do: fetch_cdr_as_csv("cdrs?file_name=#{filename}")

  @spec cdr_details(String.t()) :: {:error, any} | {:ok, any}
  def cdr_details(cdr_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "cdrs/#{cdr_id}")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec interaction_summary() :: {:error, any} | {:ok, any}
  def interaction_summary do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "cdrs/interaction")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec fetch_all_legs_interaction(String.t()) :: {:error, any} | {:ok, any}
  def fetch_all_legs_interaction(interaction_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "cdrs/legs/#{interaction_id}")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  defp fetch_cdr_as_csv(path) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, Accept: "text/csv"]

    (Utils.build_url_with_account() <> path)
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> body
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
