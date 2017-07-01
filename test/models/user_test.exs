defmodule BorrowBee.UserTest do
  use BorrowBee.ModelCase

  alias BorrowBee.User

  @valid_attrs %{email: "some content", is_admin: true, location: "some content", photo_url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
