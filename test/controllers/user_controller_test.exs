defmodule BorrowBee.UserControllerTest do
  use BorrowBee.ConnCase

  alias BorrowBee.User

  import BorrowBee.Factory
  import Plug.Test, only: [init_test_session: 2]
  @valid_attrs %{email: "some content", name: "some_content", is_admin: true, location: "some content", photo_url: "some content"}
  @invalid_attrs %{}

  setup do
    user = insert(:user)
    other_user = insert(:user)
    admin = insert(:user, is_admin: true)

    conn = build_conn() |> init_test_session(%{})
    {:ok, conn: conn, user: user, other_user: other_user, admin: admin}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing users"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "New user"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    assert redirected_to(conn) == user_path(conn, :index)
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "New user"
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    conn = get conn, user_path(conn, :show, user)
    assert html_response(conn, 200) =~ "Show user"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource when logged in as that user", %{conn: conn, user: user} do
    conn = BorrowBee.Auth.login_user(conn, user)
    conn = get conn, user_path(conn, :edit, user)
    assert html_response(conn, 200) =~ "Edit user"
  end

  test "renders form for editing chosen resource when logged in as admin", %{conn: conn, user: user, admin: admin} do
    conn = BorrowBee.Auth.login_user(conn, admin)
    conn = get conn, user_path(conn, :edit, user)
    assert html_response(conn, 200) =~ "Edit user"
  end

  test "does not render form for editing chosen resource when not logged in", %{conn: conn, user: user} do
    conn = get conn, user_path(conn, :edit, user)
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "does not render form for editing chosen resource when logged in as other_user", %{conn: conn, user: user, other_user: other_user} do
    conn = BorrowBee.Auth.login_user(conn, other_user)
    conn = get conn, user_path(conn, :edit, user)
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "updates chosen resource and redirects when data is valid and logged in ", %{conn: conn, user: user} do
    conn = BorrowBee.Auth.login_user(conn, user)
    conn = put conn, user_path(conn, :update, user), user: @valid_attrs
    assert redirected_to(conn) == user_path(conn, :show, user)
    assert Repo.get_by(User, @valid_attrs)
  end

  test "updates chosen resource and redirects when data is valid and logged in as admin ", %{conn: conn, user: user, admin: admin} do
    conn = BorrowBee.Auth.login_user(conn, admin)
    conn = put conn, user_path(conn, :update, user), user: @valid_attrs
    assert redirected_to(conn) == user_path(conn, :show, user)
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not update chosen resource and redirects when data is valid and not logged in", %{conn: conn, user: user} do
    conn = put conn, user_path(conn, :update, user), user: @valid_attrs
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "does not update chosen resource and redirects when data is valid and logged in as non-admin", %{conn: conn, user: user, other_user: other_user} do
    conn = BorrowBee.Auth.login_user(conn, other_user)
    conn = put conn, user_path(conn, :update, user), user: @valid_attrs
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "deletes chosen resource when logged in as that user", %{conn: conn, user: user} do
    conn = BorrowBee.Auth.login_user(conn, user)
    conn = delete conn, user_path(conn, :delete, user)
    assert redirected_to(conn) == user_path(conn, :index)
    refute Repo.get(User, user.id)
  end

  test "does not delete chosen resource when not logged in", %{conn: conn, user: user} do
    conn = delete conn, user_path(conn, :delete, user)
    assert redirected_to(conn) == page_path(conn, :index)
    assert Repo.get(User, user.id)
  end

end
