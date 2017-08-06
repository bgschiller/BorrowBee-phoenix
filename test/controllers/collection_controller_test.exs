defmodule BorrowBee.CollectionControllerTest do
  use BorrowBee.ConnCase

  alias BorrowBee.Collection
  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, collection_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing collections"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, collection_path(conn, :new)
    assert html_response(conn, 200) =~ "New collection"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, collection_path(conn, :create), collection: @valid_attrs
    assert redirected_to(conn) == collection_path(conn, :index)
    assert Repo.get_by(Collection, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, collection_path(conn, :create), collection: @invalid_attrs
    assert html_response(conn, 200) =~ "New collection"
  end

  test "shows chosen resource", %{conn: conn} do
    collection = Repo.insert! %Collection{}
    conn = get conn, collection_path(conn, :show, collection)
    assert html_response(conn, 200) =~ "Show collection"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, collection_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    collection = Repo.insert! %Collection{}
    conn = get conn, collection_path(conn, :edit, collection)
    assert html_response(conn, 200) =~ "Edit collection"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    collection = Repo.insert! %Collection{}
    conn = put conn, collection_path(conn, :update, collection), collection: @valid_attrs
    assert redirected_to(conn) == collection_path(conn, :show, collection)
    assert Repo.get_by(Collection, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    collection = Repo.insert! %Collection{}
    conn = put conn, collection_path(conn, :update, collection), collection: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit collection"
  end

  test "deletes chosen resource", %{conn: conn} do
    collection = Repo.insert! %Collection{}
    conn = delete conn, collection_path(conn, :delete, collection)
    assert redirected_to(conn) == collection_path(conn, :index)
    refute Repo.get(Collection, collection.id)
  end
end
