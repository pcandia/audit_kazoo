defmodule ExampleTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  import Wallaby.Query, only: [text_field: 1, button: 1]

  alias API.QubicleRecipient, as: Recipient
  alias MonsterUi, as: UI

  @username Application.get_env(:audit_kazoo, :username)
  @password Application.get_env(:audit_kazoo, :password)
  @account_name Application.get_env(:audit_kazoo, :account_name)

  describe "integration tests" do
    test "check qubicle recipient availability state", %{session: session} do
      visit(session, "/")
      |> fill_in(text_field("Username"), with: @username)
      |> fill_in(text_field("Password"), with: @password)
      |> fill_in(text_field("Account Name"), with: @account_name)
      |> click(Query.css(".login"))
      |> assert_has(Query.css(".progress-indicator"))
      |> visit("/#/apps/webhooks")
      |> assert_has(Query.css(".webhooks-header"))
      |> visit("/#/apps/callqueues-pro")
      |> assert_has(
        Query.text(
          "Hi Account Admin! Begin your session when you're ready to enter your queues.",
          count: 1
        )
      )
      |> click(button("Begin Session"))
      |> assert_has(Query.text("Queues", count: 1))

      {:ok, %{data: list_recipients}} = Recipient.list_recipients()

      recip_id =
        Enum.find(list_recipients, fn %{roles: roles} -> Map.values(roles) == ["Admin"] end)
        |> Map.get(:id)

      {:ok, %{data: data}} = Recipient.get_recipient_status(recip_id)
      assert data.availability_state == "Away"
      {:ok, %{data: %{action: "logout"}}} = Recipient.logout_recipient(recip_id)
    end

    test "test qubicle start and stop session", %{session: session} do
      UI.login(session)
      |> UI.logout()
    end
  end
end
