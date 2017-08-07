defmodule BorrowBee.CommunityTest do
  use BorrowBee.ModelCase

  alias BorrowBee.Community

  @valid_attrs %{location: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Community.changeset(%Community{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Community.changeset(%Community{}, @invalid_attrs)
    refute changeset.valid?
  end
end
