defmodule API.Sms do
  alias API.Utils

  @type sms :: %{
          from: String.t(),
          to: String.t(),
          body: String.t()
        }

  @spec sending_sms(sms()) :: {:error, any()} | {:ok, any()}
  def sending_sms(%{to: _, body: _} = data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: data})

    (Utils.build_url_with_account() <> "sms")
    |> HTTPoison.put(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
