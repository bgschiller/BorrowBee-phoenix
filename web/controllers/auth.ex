defmodule BorrowBee.Auth do
  use BorrowBee.Web, :controller

  def is_admin?(user) do
    user && user.is_admin
  end

  def admin_only(conn, _opts) do
    user = get_session(conn, :current_user)
    if is_admin?(user) do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to do that!")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end

  def login_user(conn, user) do
    conn |> put_session(:current_user, user) |> configure_session(renew: true)
  end

  def current_user(conn) do
    get_session(conn, :current_user)
  end

  def logout(conn) do
    conn |> configure_session(drop: true)
  end

end
