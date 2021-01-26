{:ok, _} = Application.ensure_all_started(:wallaby)
Application.put_env(:wallaby, :base_url, System.get_env("BASE_URL"))
ExUnit.start()
