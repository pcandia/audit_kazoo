defmodule API.Allotments do
  alias API.Utils

  @type allotment :: %{
          amount: integer(),
          cycle: String.t(),
          minimum: integer(),
          increment: integer(),
          no_consume_time: integer(),
          group_consume: list()
        }

  @spec fetch_allotments() :: {:error, any} | {:ok, any}
  def fetch_allotments do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "allotments")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec get_allotments_consumed() :: {:error, any} | {:ok, any}
  def get_allotments_consumed(), do: allotments_consumed("", "")

  @spec get_allotments_consumed_from(integer()) :: {:error, any} | {:ok, any}
  def get_allotments_consumed_from(timestamp), do: allotments_consumed(timestamp, "")

  @spec get_allotments_consumed_to(integer()) :: {:error, any} | {:ok, any}
  def get_allotments_consumed_to(timestamp), do: allotments_consumed("", timestamp)

  @spec update_allotment(allotment()) :: {:error, any} | {:ok, any}
  def update_allotment(%{amount: _, cycle: _} = data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: data})

    (Utils.build_url_with_account() <> "allotments")
    |> HTTPoison.post(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  defp allotments_consumed(created_from, created_to) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    url =
      case {created_from, created_to} do
        {"", ""} -> "allotments/consumed"
        {from, ""} -> "allotments/consumed?created_from=#{from}"
        {"", to} -> "allotments/consumed?created_to=#{to}"
        {from, to} -> "allotments/consumed?created_from=#{from}&created_to=#{to}"
      end

    (Utils.build_url_with_account() <> url)
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
