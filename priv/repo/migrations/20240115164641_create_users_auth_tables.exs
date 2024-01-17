defmodule Match_MVP.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users) do
      add :username, :citext, null: false
      add :hashed_password, :string, null: false
      add :deposit, :float, default: 0
      add :role, :string, null: false

      timestamps()
    end

    create unique_index(:users, [:username])
  end
end
