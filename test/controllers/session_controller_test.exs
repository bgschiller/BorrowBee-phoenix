defmodule BorrowBee.SessionControllerTest do
  use BorrowBee.ConnCase

  import BorrowBee.Factory
  import Plug.Test, only: [init_test_session: 2]


  test "navigating to the link in email logs us in", %{} do
    user = insert(:user)
    conn = build_conn() |> init_test_session(%{})

    conn = post conn, session_path(conn, :create), user: %{"email" => user.email}
    assert redirected_to(conn) == page_path(conn, :index)

    login_token = Repo.get_by(BorrowBee.LoginToken, user_id: user.id)
    assert login_token

    refute get_session(conn, :current_user)
    conn = get conn, user_session_url(conn, :show, user, login_token.token)
    assert get_session(conn, :current_user)
  end

  test "We send an email with the token", %{} do
    # test specifically create_token_and_send_email(user) instead of the whole post
    user = insert(:user)

    conn = build_conn() |> init_test_session(%{})

    BorrowBee.Mailer.Mock.clear
    conn = post conn, session_path(conn, :create), user: %{"email" => user.email}
    assert redirected_to(conn) == page_path(conn, :index)
    # This sometimes fails, saying 0 != 1.
    assert BorrowBee.Mailer.Mock.mails |> length == 1

    login_token = Repo.get_by(BorrowBee.LoginToken, user_id: user.id)
    assert login_token

    [mail] = BorrowBee.Mailer.Mock.mails
    assert mail.text =~ user_session_url(conn, :show, user, login_token.token)
  end

  test "Login link can only be used once" do
    user = insert(:user)
    conn = build_conn() |> init_test_session(%{})

    conn = post conn, session_path(conn, :create), user: %{"email" => user.email}
    assert redirected_to(conn) == page_path(conn, :index)

    login_token = Repo.get_by(BorrowBee.LoginToken, user_id: user.id)
    assert login_token

    refute get_session(conn, :current_user)
    conn = get conn, user_session_url(conn, :show, user, login_token.token)
    assert get_session(conn, :current_user)

    conn2 = build_conn() |> init_test_session(%{})
    conn2 = get conn2, user_session_url(conn, :show, user, login_token.token)

    assert get_flash(conn2, :error) == "Access token not found or expired"
    assert redirected_to(conn2) == page_path(conn2, :index)
    refute get_session(conn2, :current_user)
  end

  test "Login link expires after 15 minutes" do
    user = insert(:user)
    conn = build_conn() |> init_test_session(%{})

    conn = post conn, session_path(conn, :create), user: %{"email" => user.email}
    assert redirected_to(conn) == page_path(conn, :index)

    login_token = Repo.get_by(BorrowBee.LoginToken, user_id: user.id)
    assert login_token

    Ecto.Adapters.SQL.query(Repo, """
UPDATE login_tokens SET
  inserted_at = inserted_at - interval '16 minute'
WHERE id = $1
RETURNING *
    """, [login_token.id])

    refute get_session(conn, :current_user)
    conn = get conn, user_session_url(conn, :show, user, login_token.token)
    refute get_session(conn, :current_user)
  end

end
