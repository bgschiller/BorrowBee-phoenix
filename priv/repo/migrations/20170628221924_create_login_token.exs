defmodule BorrowBee.Repo.Migrations.CreateLoginToken do
  use Ecto.Migration

  def change do
    create table(:login_tokens) do
      add :token, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:login_tokens, [:user_id])

  end
end
