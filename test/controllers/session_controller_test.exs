defmodule BorrowBee.SessionControllerTest do
  use BorrowBee.ConnCase

  import BorrowBee.Factory
  import Plug.Test, only: [init_test_session: 2]

  setup do
    user = insert(:user)
    other_user = insert(:user)

    conn = build_conn() |> init_test_session(%{})
    {:ok, conn: conn, user: user, other_user: other_user}
  end

  test "We send an email with the token", %{conn: conn, user: user} do
    conn = post conn, session_path(conn, :create), user: %{"email" => user.email}
    assert redirected_to(conn) == page_path(conn, :index)

    login_token = Repo.get_by(BorrowBee.LoginToken, user_id: user.id)
    assert login_token

    assert BorrowBee.Mailer.Mock.mails |> length == 1
    [mail] = BorrowBee.Mailer.Mock.mails

    assert mail.text =~ user_session_url(conn, :show, user, login_token.token)
  end

  test "navigating to the link in email logs us in", %{conn: conn, user: user} do
    conn = post conn, session_path(conn, :create), user: %{"email" => user.email}
    assert redirected_to(conn) == page_path(conn, :index)

    login_token = Repo.get_by(BorrowBee.LoginToken, user_id: user.id)
    assert login_token

    refute get_session(conn, :current_user)
    conn = get conn, user_session_url(conn, :show, user, login_token.token)
    assert get_session(conn, :current_user)
  end

end
