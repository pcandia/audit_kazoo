defmodule API.Hotdesks do
  alias API.Utils

  @spec fetch_hotdesks() :: {:error, any()} | {:ok, any()}
  def fetch_hotdesks do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "hotdesks")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
