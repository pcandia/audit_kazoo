defmodule API.Dialplans do
  require Logger

  alias API.Utils

  @spec fetch_dialplans() :: {:error, any()} | {:ok, any()}
  def fetch_dialplans do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "dialplans")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} ->
        Utils.decode(body)

      {:ok, %{status_code: 404}} ->
        Logger.info(
          "Make sure the dialplans API endpoint is started, by API.Sup.apply(:crossbar, :start_module, :cb_dialplans)"
        )

      {:error, %{reason: reason}} ->
        {:error, reason}
    end
  end
end
