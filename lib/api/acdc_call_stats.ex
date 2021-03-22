defmodule API.AcdcCallStats do
  require Logger

  alias API.Utils

  @spec fetch_acdc_call_stats() :: {:error, any()} | {:ok, any()}
  def fetch_acdc_call_stats, do: fetch_acdc_call_stats([])

  @spec fetch_acdc_call_stats_as_csv() :: {:error, any()} | {:ok, any()}
  def fetch_acdc_call_stats_as_csv, do: fetch_acdc_call_stats(Accept: :"text/csv")

  @spec fetch_acdc_call_stats_by_timestamps(String.t(), String.t()) ::
          {:error, any()} | {:ok, any()}
  def fetch_acdc_call_stats_by_timestamps(from_timestamp, to_timestamp),
    do: fetch_acdc_call_stats([], from_timestamp, to_timestamp)

  defp fetch_acdc_call_stats(accept_type, from_timestamp \\ "", to_timestamp \\ "") do
    auth_token = Utils.get_auth_token()
    header = Keyword.merge(["X-Auth-Token": auth_token], accept_type)

    (Utils.build_url_with_account() <>
       "acdc_call_stats?created_from=#{from_timestamp}&created_to=#{to_timestamp}")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
