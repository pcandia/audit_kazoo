{:ok, _} = Application.ensure_all_started(:wallaby)
Application.put_env(:wallaby, :base_url, "http://192.168.0.6")
ExUnit.start()
