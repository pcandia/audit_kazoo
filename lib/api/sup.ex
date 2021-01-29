defmodule API.Sup do
  alias API.Utils

  @url Application.get_env(:audit_kazoo, :base_url)

  @spec apply(atom() | String.t(), atom() | String.t(), atom() | String.t() | list()) ::
          {:error, any} | {:ok, any}
  def apply(module, function \\ "", args \\ []) do
    # NOTE all modules will become {MODULE}_maintenance
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    "#{@url}:8000/v2/sup"
    |> build_url(module)
    |> build_url(function)
    |> build_url(args)
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  defp build_url(url, ""), do: url
  defp build_url(url, []), do: url
  defp build_url(url, [arg1 | args]), do: build_url("#{url}/#{arg1}", args)
  defp build_url(url, param), do: "#{url}/#{param}"
end
