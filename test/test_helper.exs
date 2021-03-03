{:ok, _} = Application.ensure_all_started(:wallaby)
Application.put_env(:wallaby, :base_url, Application.get_env(:audit_kazoo, :base_url))
ExUnit.start()

{:ok, files} = File.ls("./test/support")

Enum.each(files, fn file ->
  Code.require_file("support/#{file}", __DIR__)
end)
