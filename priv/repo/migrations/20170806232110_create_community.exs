defmodule BorrowBee.Repo.Migrations.CreateCommunity do
  use Ecto.Migration

  def change do
    create table(:communities) do
      add :name, :string
      add :location, :string

      timestamps()
    end

  end
end
