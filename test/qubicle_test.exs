defmodule QubicleTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  import Wallaby.Query, only: [text_field: 1, button: 1]

  describe "qubicle test" do
    test "trying login", %{session: session} do
      visit(session, "/")
      |> fill_in(text_field("Username"), with: "admin")
      |> fill_in(text_field("Password"), with: "password123")
      |> fill_in(text_field("Account Name"), with: "master-account")
      |> click(Query.css(".login"))
      |> assert_has(Query.css(".progress-indicator"))
      |> visit("/#/apps/webhooks")
      |> assert_has(Query.css(".webhooks-header"))
      |> visit("/#/apps/callqueues-pro")
      |> assert_has(Query.text("Hi Account Admin! Begin your session when you're ready to enter your queues.", count: 1))
      |> click(button("Begin Session"))
      |> assert_has(Query.text("Queues", count: 2))
    end
  end
end
