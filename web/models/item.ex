defmodule BorrowBee.Item do
  use BorrowBee.Web, :model

  schema "items" do
    field :name, :string
    field :desc, :string
    field :notes_from_owner, :string
    field :photo_url, :string
    field :isbn, :string
    belongs_to :user, BorrowBee.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :desc, :notes_from_owner, :photo_url, :isbn])
    |> validate_required([:name, :desc, :notes_from_owner, :photo_url, :isbn])
  end
end
