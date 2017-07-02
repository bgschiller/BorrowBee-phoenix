defmodule BorrowBee.Mailer.Mock do
  @behaviour BorrowBee.Mailer.Behaviour

  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def mails do
    Agent.get(__MODULE__, &(&1))
  end

  def clear do
    Agent.update(__MODULE__, fn _mails -> [] end)
  end

  def send_mail(mail) do
    mail = mail |> Enum.into(%{})
    Agent.update(__MODULE__, fn existing_mails -> [mail | existing_mails] end)
    :ok
  end
end
