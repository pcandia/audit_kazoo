defmodule API.Menus do
  alias API.Utils

  @type menu :: %{
          name: String.t(),
          allow_record_from_offnet: boolean(),
          hunt: boolean(),
          hunt_allow: String.t(),
          hunt_deny: String.t(),
          interdigit_timeout: integer(),
          max_extension_length: integer(),
          media: map(),
          record_pin: String.t(),
          retries: integer(),
          suppress_media: boolean()
        }

  @spec fetch_menus() :: {:error, any()} | {:ok, any()}
  def fetch_menus do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "menus")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec fetch_menu(String.t()) :: {:error, any()} | {:ok, any()}
  def fetch_menu(menu_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "menus/#{menu_id}")
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec create_menu(menu()) :: {:error, any()} | {:ok, any()}
  def create_menu(%{name: _} = data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: data})

    (Utils.build_url_with_account() <> "menus")
    |> HTTPoison.put(body, header)
    |> case do
      {:ok, %{body: body, status_code: 201}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec change_menu(String.t(), menu()) :: {:error, any()} | {:ok, any()}
  def change_menu(menu_id, %{name: _} = data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: data})

    (Utils.build_url_with_account() <> "menus/#{menu_id}")
    |> HTTPoison.post(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec patch_menu(String.t(), menu()) :: {:error, any()} | {:ok, any()}
  def patch_menu(menu_id, menu_patch) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: menu_patch})

    (Utils.build_url_with_account() <> "menus/#{menu_id}")
    |> HTTPoison.patch(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec remove_menu(String.t()) :: {:error, any()} | {:ok, any()}
  def remove_menu(menu_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    (Utils.build_url_with_account() <> "menus/#{menu_id}")
    |> HTTPoison.delete(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
