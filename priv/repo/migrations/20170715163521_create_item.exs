defmodule BorrowBee.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :desc, :text
      add :notes_from_owner, :text
      add :photo_url, :string
      add :isbn, :string
      add :user, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:items, [:user])
    create index(:items, [:inserted_at])
    create index(:items,
      ["to_tsvector('english', name) || to_tsvector('english', desc)"],
      name: :items_name_desc_vector, using: "GIN")

  end
end
