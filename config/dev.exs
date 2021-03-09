use Mix.Config

config :wallaby, otp_app: :audit_kazoo

config :wallaby, :sql_sandbox, true

# Chrome
config :wallaby, driver: Wallaby.Chrome

config :wallaby,
  hackney_options: [timeout: :infinity, recv_timeout: :infinity]

config :audit_kazoo, base_url: System.get_env("BASE_URL")
config :audit_kazoo, webhook_uri: System.get_env("LOCALHOST_IP")
config :audit_kazoo, username: System.get_env("USERNAME")
config :audit_kazoo, password: System.get_env("PASSWORD")
config :audit_kazoo, account_name: System.get_env("ACCOUNT_NAME")
config :audit_kazoo, account_id: System.get_env("ACCOUNT_ID")
