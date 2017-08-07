defmodule BorrowBee.Repo.Migrations.UserMembershipInCommunity do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :community_ids, {:array, :id}
    end
  end
end
