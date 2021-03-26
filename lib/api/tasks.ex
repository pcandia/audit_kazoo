defmodule API.Tasks do
  alias API.Utils

  @spec list_all_tasks() :: {:error, any} | {:ok, any}
  def list_all_tasks do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "tasks")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
