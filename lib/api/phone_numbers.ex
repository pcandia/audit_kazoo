defmodule API.PhoneNumbers do
  alias API.Utils

  @type phone_number :: %{
          carrier_name: String.t(),
          create_with_state: String.t(),
          cnam: map(),
          e911: map(),
          porting: map()
        }

  @spec list_account_phone_numbers() :: {:error, any} | {:ok, any}
  def list_account_phone_numbers do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "phone_numbers")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec filter_phone_numbers(map()) :: {:error, any} | {:ok, any}
  def filter_phone_numbers(filters) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "phone_numbers?" <> build_filters(filters))
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec search_for_available_numbers(String.t(), String.t(), String.t(), String.t()) ::
          {:error, any} | {:ok, any}
  def search_for_available_numbers(prefix, quantity, offset, country) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <>
       "phone_numbers?" <>
       "prefix=#{prefix}&" <>
       "quantity=#{quantity}&" <> "offset=#{offset}&" <> "country=#{country}")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec carriers_info() :: {:error, any} | {:ok, any}
  def carriers_info do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "phone_numbers/carriers_info")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec delete_phone_number(String.t()) :: {:error, any} | {:ok, any}
  def delete_phone_number(phone_number) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "phone_numbers" <> "/#{phone_number}")
    |> HTTPoison.delete(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec check_phone_numbers(list()) :: {:error, any} | {:ok, any}
  def check_phone_numbers(list_of_numbers) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: %{numbers: list_of_numbers}})

    (Utils.build_url_with_account() <> "phone_numbers/check")
    |> HTTPoison.post(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec add_list_of_numbers(list()) :: {:error, any} | {:ok, any}
  def add_list_of_numbers(list_of_numbers) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: %{numbers: list_of_numbers}})

    (Utils.build_url_with_account() <> "phone_numbers/collection")
    |> HTTPoison.put(body, header)
    |> case do
      {:ok, %{body: body, status_code: 201}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec get_by_phone_number(String.t()) :: {:error, any} | {:ok, any}
  def get_by_phone_number(phone_number) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "phone_numbers/#{phone_number}")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  defp build_filters(filters_map) do
    Map.to_list(filters_map)
    |> Enum.reduce("", fn {key, value}, acc ->
      acc <> Atom.to_string(key) <> "=#{value}&"
    end)
  end
end
