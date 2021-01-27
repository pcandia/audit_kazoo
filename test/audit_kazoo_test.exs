defmodule AuditKazooTest do
  use ExUnit.Case
  doctest AuditKazoo

  test "greets the world" do
    assert AuditKazoo.hello() == :world
    assert :ok == Application.ensure_started(:audit_kazoo)
  end
end
