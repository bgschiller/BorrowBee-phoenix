defmodule BorrowBee.LoginToken do
  use BorrowBee.Web, :model

  schema "login_tokens" do
    field :token, :string, null: false
    belongs_to :user, BorrowBee.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :token])
    |> validate_required([:user_id, :token])
  end
end
