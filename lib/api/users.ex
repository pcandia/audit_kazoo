defmodule API.Users do
  alias API.Utils

  @url Application.get_env(:audit_kazoo, :base_url)
  @account_id Application.get_env(:audit_kazoo, :account_id)

  @type user :: %{
          first_name: String.t(),
          last_name: String.t(),
          call_restriction: map(),
          caller_id: map(),
          contact_list: map(),
          dial_plan: map(),
          enabled: boolean(),
          hotdesk: %{
            enabled: boolean(),
            keep_logged_in_elsewhere: boolean(),
            require_pin: boolean()
          },
          media: %{
            audio: %{codecs: list()},
            encryption: %{enforce_security: boolean(), methods: list()},
            video: %{codecs: list()}
          },
          music_on_hold: map(),
          priv_level: String.t(),
          profile: map(),
          require_password_update: boolean(),
          ringtones: boolean(),
          verified: boolean(),
          vm_to_email_enabled: boolean()
        }

  @spec fetch_users() :: {:error, any} | {:ok, any}
  def fetch_users do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    "#{@url}:8000/v2/accounts/#{@account_id}/users"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec fetch_user(String.t()) :: {:error, any} | {:ok, any}
  def fetch_user(user_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    "#{@url}:8000/v2/accounts/#{@account_id}/users/#{user_id}"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec create_user(%{first_name: String.t(), last_name: String.t()}) ::
          {:error, any} | {:ok, any}
  def create_user(%{first_name: _, last_name: _} = data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: data})

    "#{@url}:8000/v2/accounts/#{@account_id}/users"
    |> HTTPoison.put(body, header)
    |> case do
      {:ok, %{body: body, status_code: 201}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec delete_user(String.t()) :: {:error, any} | {:ok, any}
  def delete_user(user_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    "#{@url}:8000/v2/accounts/#{@account_id}/users/#{user_id}"
    |> HTTPoison.delete(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec patch_user(String.t(), boolean()) :: {:error, any} | {:ok, any}
  def patch_user(user_id, enable_true_or_false) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: %{enabled: enable_true_or_false}})

    "#{@url}:8000/v2/accounts/#{@account_id}/users/#{user_id}"
    |> HTTPoison.patch(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec update_user(String.t(), user()) :: {:error, any} | {:ok, any}
  def update_user(user_id, data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: data})

    "#{@url}:8000/v2/accounts/#{@account_id}/users/#{user_id}"
    |> HTTPoison.post(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
