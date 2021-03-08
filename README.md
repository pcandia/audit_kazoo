# AuditKazoo

This repo provides a client consumer for [Kazoo's API (Crossbar)](https://github.com/2600hz/kazoo) and its family applications.. It also can manage webhooks to listen to incoming events.

Make sure sup module is running in the Kazoo API
`crossbar_maintenance:start_module(cb_sup).`

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_interval` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_interval, "~> 0.1.0"}
  ]
end
```
