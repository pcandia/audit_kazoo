defmodule API.Devices do
  alias API.Utils

  @url Application.get_env(:audit_kazoo, :base_url)
  @account_id Application.get_env(:audit_kazoo, :account_id)

  @type device :: %{
          name: String.t(),
          call_forward: map(),
          call_restriction: map(),
          caller_id_options: map(),
          contact_list: map(),
          device_type: String.t(),
          do_not_disturb: map(),
          enabled: boolean(),
          exclude_from_queues: boolean(),
          flags: list(),
          hotdesk: map(),
          language: String.t(),
          mac_address: String.t(),
          music_on_hold: map(),
          mwi_unsolicited_updates: boolean(),
          outbound_flags: map(),
          owner_id: String.t(),
          presence_id: String.t(),
          provision: map(),
          register_overwrite_notify: boolean(),
          ringtones: map(),
          sip: map(),
          suppress_unregister_notifications: boolean()
        }

  @spec fetch_devices() :: {:error, any} | {:ok, any}
  def fetch_devices do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    "#{@url}:8000/v2/accounts/#{@account_id}/devices"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec fetch_device(String.t()) :: {:error, any} | {:ok, any}
  def fetch_device(device_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    "#{@url}:8000/v2/accounts/#{@account_id}/devices/#{device_id}"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec devices_statuses() :: {:error, any} | {:ok, any}
  def devices_statuses do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    "#{@url}:8000/v2/accounts/#{@account_id}/devices/status"
    |> HTTPoison.get(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec reboot_device(String.t()) :: {:error, any} | {:ok, any}
  def reboot_device(device_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    "#{@url}:8000/v2/accounts/#{@account_id}/devices/#{device_id}/sync"
    |> HTTPoison.post("", header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec create_new_device(device()) :: {:error, any} | {:ok, any}
  def create_new_device(%{name: _device_name} = data) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: data})

    "#{@url}:8000/v2/accounts/#{@account_id}/devices"
    |> HTTPoison.put(body, header)
    |> case do
      {:ok, %{body: body, status_code: 201}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec remove_device(String.t()) :: {:error, any} | {:ok, any}
  def remove_device(device_id) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token]

    "#{@url}:8000/v2/accounts/#{@account_id}/devices/#{device_id}"
    |> HTTPoison.delete(header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  @spec update_device(map()) :: {:error, any} | {:ok, any}
  def update_device(device) do
    auth_token = Utils.get_auth_token()
    header = ["X-Auth-Token": auth_token, "Content-Type": :"application/json"]
    body = Poison.encode!(%{data: device})

    "#{@url}:8000/v2/accounts/#{@account_id}/devices/#{device.id}"
    |> HTTPoison.post(body, header)
    |> case do
      {:ok, %{body: body, status_code: 200}} -> Utils.decode(body)
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end
end
