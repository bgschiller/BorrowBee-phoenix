defmodule BorrowBee.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :description, :text
      add :notes_from_owner, :text
      add :photo_url, :string
      add :isbn, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:items, [:user_id])
    create index(:items, [:inserted_at])
    create index(:items,
      ["to_tsvector('english', name || ' ' || description)"],
      name: :items_name_desc_vector, using: "GIN")
  end
end
