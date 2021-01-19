defmodule AuditKazooTest do
  use ExUnit.Case
  doctest AuditKazoo

  test "greets the world" do
    assert AuditKazoo.hello() == :world
  end
end
