defmodule BorrowBee.Repo.Migrations.MembershipManyToMany do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :community_ids
    end
    create table(:memberships, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :community_id, references(:communities, on_delete: :delete_all)
    end
  end
end
