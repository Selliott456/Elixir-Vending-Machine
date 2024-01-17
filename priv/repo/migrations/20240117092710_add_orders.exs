defmodule Match_MVP.Repo.Migrations.AddOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :basket, {:array, :map}, null: false
      add :total_cost, :float, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:orders, [:user_id])
    create unique_index(:orders, [:id])
  end
end
