defmodule API.Rates do
  alias API.Utils

  @spec list_all_rates() :: {:error, any()} | {:ok, any()}
  def list_all_rates do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, Accept: :"application/json"]

    (Utils.build_url() <> "rates")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec list_rates_by_prefix(String.t()) :: {:error, any()} | {:ok, any()}
  def list_rates_by_prefix(prefix) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, Accept: :"application/json"]

    (Utils.build_url() <> "rates?prefix=#{prefix}")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec create_rate(map()) :: {:error, any()} | {:ok, any()}
  def create_rate(%{prefix: _, rate_cost: _} = rates) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: rates})

    (Utils.build_url() <> "rates")
    |> HTTPoison.put(body, header)
    |> case do
      {:ok, %{body: body, status_code: 201}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec fetch_rate(String.t()) :: {:error, any()} | {:ok, any()}
  def fetch_rate(rate_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url() <> "rates/#{rate_id}")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec update_rate(map()) :: {:error, any()} | {:ok, any()}
  def update_rate(%{id: rate_id} = rate) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: rate})

    (Utils.build_url() <> "rates/#{rate_id}")
    |> HTTPoison.post(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec delete_rate(String.t()) :: {:error, any()} | {:ok, any()}
  def delete_rate(rate_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url() <> "rates/#{rate_id}")
    |> HTTPoison.delete(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
