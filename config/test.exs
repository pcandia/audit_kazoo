use Mix.Config

config :wallaby, otp_app: :audit_kazoo

config :wallaby, :sql_sandbox, true

# Chrome
config :wallaby, driver: Wallaby.Chrome # default

# Selenium
config :wallaby, driver: Wallaby.Selenium

config :audit_kazoo, url: System.get_env("BASE_URL")
