defmodule BorrowBee.MailerTest do
  use ExUnit.Case

  test "it uses mock in tests" do
    BorrowBee.Mailer.Mock.clear
    BorrowBee.Mailer.send_test_mail("me@example.com")

    assert BorrowBee.Mailer.Mock.mails |> length == 1

    [mail] = BorrowBee.Mailer.Mock.mails

    assert mail.to == "me@example.com"
    assert mail.text == "Test from BorrowBee"
  end
end
