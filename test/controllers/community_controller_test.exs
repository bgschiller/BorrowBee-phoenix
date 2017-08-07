defmodule BorrowBee.CommunityControllerTest do
  use BorrowBee.ConnCase

  alias BorrowBee.Community
  @valid_attrs %{location: "some content", name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, community_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing communities"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, community_path(conn, :new)
    assert html_response(conn, 200) =~ "New community"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, community_path(conn, :create), community: @valid_attrs
    assert redirected_to(conn) == community_path(conn, :index)
    assert Repo.get_by(Community, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, community_path(conn, :create), community: @invalid_attrs
    assert html_response(conn, 200) =~ "New community"
  end

  test "shows chosen resource", %{conn: conn} do
    community = Repo.insert! %Community{}
    conn = get conn, community_path(conn, :show, community)
    assert html_response(conn, 200) =~ "Show community"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, community_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    community = Repo.insert! %Community{}
    conn = get conn, community_path(conn, :edit, community)
    assert html_response(conn, 200) =~ "Edit community"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    community = Repo.insert! %Community{}
    conn = put conn, community_path(conn, :update, community), community: @valid_attrs
    assert redirected_to(conn) == community_path(conn, :show, community)
    assert Repo.get_by(Community, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    community = Repo.insert! %Community{}
    conn = put conn, community_path(conn, :update, community), community: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit community"
  end

  test "deletes chosen resource", %{conn: conn} do
    community = Repo.insert! %Community{}
    conn = delete conn, community_path(conn, :delete, community)
    assert redirected_to(conn) == community_path(conn, :index)
    refute Repo.get(Community, community.id)
  end
end
