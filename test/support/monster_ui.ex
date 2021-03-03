defmodule MonsterUi do
  alias Wallaby.Browser
  import Wallaby.Query, only: [text_field: 1, css: 1]

  @username Application.get_env(:audit_kazoo, :username)
  @password Application.get_env(:audit_kazoo, :password)
  @account_name Application.get_env(:audit_kazoo, :account_name)

  @spec kazoo_login(Wallaby.Session.t()) :: Wallaby.Session.t()
  def kazoo_login(session) do
    Browser.visit(session, "/")
    |> Browser.fill_in(text_field("Username"), with: @username)
    |> Browser.fill_in(text_field("Password"), with: @password)
    |> Browser.fill_in(text_field("Account Name"), with: @account_name)
    |> Browser.click(css(".login"))
  end

  @spec kazoo_logout(Wallaby.Session.t()) :: Wallaby.Session.t()
  def kazoo_logout(session) do
    Browser.click(session, css(".fa-sign-out"))
  end
end
