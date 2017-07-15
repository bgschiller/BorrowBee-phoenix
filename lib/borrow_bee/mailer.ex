defmodule BorrowBee.Mailer do
  use Mailgun.Client, [
    domain: Application.fetch_env!(:borrow_bee, :mailgun_domain),
    key: Application.fetch_env!(:borrow_bee, :mailgun_key)
  ]

  alias BorrowBee.{Endpoint, Router}

  require Logger

  def send_login_token(user, token) do
    Logger.info "Emailing login token to #{user.email}"
    send_email(
      to: user.email,
      from: "noreply@borrowbee.org",
      subject: "Log In to BorrowBee",
      text: """
Here is your login link to BorrowBee: #{token_url(user, token)}
This url will expire in 15 minutes, and can only be used once. But don't worry, you can always get another one :)
Treat this link like a password. If you forward it to anyone, they will be able to login as you.
"""
    )
  end

  defp token_url(user, token) do
    Router.Helpers.user_session_url(Endpoint, :show, user, token)
  end

end
