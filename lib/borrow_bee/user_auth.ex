defmodule BorrowBee.UserAuth do
  alias BorrowBee.{LoginToken, User}
  alias BorrowBee.Mailer
  alias BorrowBee.Repo

  def send_login_token(user_params, maybe_send_token_email \\ &send_token_email/2) do
    with {:ok, user} <- get_or_create_user(user_params),
         {:ok, token} <- create_token(user),
         {:ok} <- maybe_send_token_email.(user, token)
    do
      {:ok, user, token}
    else
      {:error, _changeset} = error ->
        error
      _ ->
        {:error, "something went wrong"}
    end
  end

  def create_token(user) do
    token = generate_token()
    Repo.insert!(%LoginToken{user_id: user.id, token: token})
    {:ok, token}
  end

  def get_or_create_user(%{"email" => email} = user_params) do
    user_email = String.downcase(email)
    user_struct =
      case Repo.get_by(User, email: user_email) do
        nil -> %User{email: user_email}
        user -> user
      end
      |> User.changeset(user_params)
    Repo.insert_or_update(user_struct)
  end

  defp generate_token do
    :crypto.strong_rand_bytes(20) |> Base.url_encode64 |> binary_part(0, 20)
  end

  defp send_token_email(user, token) do
    Task.async(fn -> Mailer.send_login_token(user, token) end)
    {:ok}
  end

end
