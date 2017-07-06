defmodule BorrowBee.SessionControllerTest do
  use BorrowBee.ConnCase

  import BorrowBee.Factory
  import Plug.Test, only: [init_test_session: 2]


  test "navigating to the link in email logs us in", %{} do
    user = insert(:user)
    conn = build_conn() |> init_test_session(%{})

    conn = post conn, session_path(conn, :create), user: %{"email" => user.email}
    assert redirected_to(conn) == page_path(conn, :index)

    # This line does nothing but slow us down (I think)
    Repo.all(from x in BorrowBee.LoginToken)

    login_token = Repo.get_by(BorrowBee.LoginToken, user_id: user.id)
    assert login_token

    refute get_session(conn, :current_user)
    conn = get conn, user_session_url(conn, :show, user, login_token.token)
    assert get_session(conn, :current_user)
  end

  test "navigating to the link in email logs us in (Again)", %{} do
    # This is a copy of the above test. Running just these two identical tests
    # without the `Repo.all(from x in BorrowBee.LoginToken)` will usually fail.
    user = insert(:user)
    conn = build_conn() |> init_test_session(%{})

    conn = post conn, session_path(conn, :create), user: %{"email" => user.email}
    assert redirected_to(conn) == page_path(conn, :index)

    # This line does nothing but slow us down (I think)
    Repo.all(from x in BorrowBee.LoginToken)

    login_token = Repo.get_by(BorrowBee.LoginToken, user_id: user.id)
    assert login_token

    refute get_session(conn, :current_user)
    conn = get conn, user_session_url(conn, :show, user, login_token.token)
    assert get_session(conn, :current_user)
  end


  test "We send an email with the token", %{} do
    user = insert(:user)

    conn = build_conn() |> init_test_session(%{})

    BorrowBee.Mailer.Mock.clear
    conn = post conn, session_path(conn, :create), user: %{"email" => user.email}
    assert redirected_to(conn) == page_path(conn, :index)
    # This sometimes fails, saying 0 != 1.
    assert BorrowBee.Mailer.Mock.mails |> length == 1

    # This line does nothing but slow us down (I think)
    Repo.all(from x in BorrowBee.LoginToken)

    login_token = Repo.get_by(BorrowBee.LoginToken, user_id: user.id)
    assert login_token

    [mail] = BorrowBee.Mailer.Mock.mails
    assert mail.text =~ user_session_url(conn, :show, user, login_token.token)
  end


end
