defmodule BorrowBee.User do
  use BorrowBee.Web, :model

  alias BorrowBee.{LoginToken, Item, Collection, Community}
  require Logger

  schema "users" do
    field :email, :string
    field :name, :string
    field :photo_url, :string
    field :location, :string
    field :is_admin, :boolean, default: false

    timestamps()

    many_to_many :communities, Community, join_through: "memberships"
    has_many :login_token, LoginToken
    has_many :items, Item
    has_many :collections, Collection
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :name, :photo_url, :location, :is_admin])
    |> update_change(:email, &String.downcase/1)
    |> validate_required([:email])
    |> unique_constraint(:email)
  end

end
