defmodule BorrowBee.Collection do
  use BorrowBee.Web, :model

  schema "collections" do
    field :name, :string
    field :description, :string
    belongs_to :user, BorrowBee.User
    many_to_many :items, BorrowBee.Item, join_through: "item_memberships"

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description])
    |> validate_required([:name])
  end
end
