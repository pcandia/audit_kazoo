defmodule API.Sup do
  alias API.Utils

  @url Application.get_env(:audit_kazoo, :base_url)

  @spec exec(atom(), atom(), atom()) :: {:error, any} | {:ok, any}
  def exec(module, function, args) do
    # current not working
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    "#{@url}:8000/v2/sup/#{module}/#{function}/#{args}"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
