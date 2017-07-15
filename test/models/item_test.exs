defmodule BorrowBee.ItemTest do
  use BorrowBee.ModelCase

  alias BorrowBee.Item

  @valid_attrs %{desc: "some content", isbn: "some content", name: "some content", notes_from_owner: "some content", photo_url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Item.changeset(%Item{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Item.changeset(%Item{}, @invalid_attrs)
    refute changeset.valid?
  end
end
