defmodule BorrowBee.Mailer do
  alias BorrowBee.{Endpoint, Router}

  require Logger

  @mailer_impl Application.fetch_env!(:borrow_bee, :mailer)

  defmodule Behaviour do
    @callback send_mail([key: String.t]) :: :ok
  end

  def send_login_token(user, token) do
    Logger.info "Emailing login token to #{user.email}"
    :ok = @mailer_impl.send_mail(
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

  def send_test_mail(email) do
   :ok = @mailer_impl.send_mail(
     to: email,
     from: "noreply@borrowbee.org",
     subject: "Test!",
     text: "Test from BorrowBee"
   )
   :ok
 end
end
