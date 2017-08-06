defmodule BorrowBee.Repo.Migrations.CreateCollection do
  use Ecto.Migration

  def change do
    create table(:collections) do
      add :name, :string
      add :description, :string, null: true
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
    create index(:collections, [:user_id])


    create table(:item_memberships) do
      add :collection_id, references(:collections)
      add :item_id, references(:items)
    end
    create index(:item_memberships, [:collection_id])
    create index(:item_memberships, [:item_id])
  end
end
