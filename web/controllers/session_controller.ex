defmodule BorrowBee.SessionController do
  use BorrowBee.Web, :controller

  alias BorrowBee.User
  alias BorrowBee.LoginToken
  alias BorrowBee.UserAuth

  import Ecto.Query

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    case UserAuth.send_login_token(user_params) do
      {:ok, _user, _token} ->
        conn
        |> put_flash(:info, "We sent you a link to log in. Please check your inbox.")
        |> redirect(to: page_path(conn, :index))
      {:error, message, changeset} ->
        render(conn, "new.html", error: message, changeset: changeset)
    end
  end

  def show(conn, %{"user_id" => user_id, "id" => token}) do
    login_token = Repo.one from lt in  LoginToken,
              where: lt.user_id == ^user_id and lt.token == ^token and
                lt.inserted_at > datetime_add(^Ecto.DateTime.utc, -15, "minute")

    case login_token do
      nil ->
        conn
          |> put_flash(:error, "Access token not found or expired")
          |> redirect(to: page_path(conn, :index))
      _ ->
        user = Repo.get_by!(User, id: user_id)
        Repo.delete!(%LoginToken{id: login_token.id})  # only to be used once
        conn
         |> BorrowBee.Auth.login_user(user)
         |> put_flash(:info, "Welcome #{user.name || user.email}")
         |> redirect(to: page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> BorrowBee.Auth.logout()
    |> put_flash(:info, "User logged out.")
    |> redirect(to: page_path(conn, :index))
  end
end
