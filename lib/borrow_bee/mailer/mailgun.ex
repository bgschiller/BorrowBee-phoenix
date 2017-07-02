defmodule BorrowBee.Mailer.Mailgun do
  @behaviour BorrowBee.Mailer.Behaviour

  use Mailgun.Client, [
    domain: Application.fetch_env!(:borrow_bee, :mailgun_domain),
    key: Application.fetch_env!(:borrow_bee, :mailgun_key)
  ]

  def send_mail(mail) do
    {:ok, _} = send_email(mail)
    :ok
  end
end
