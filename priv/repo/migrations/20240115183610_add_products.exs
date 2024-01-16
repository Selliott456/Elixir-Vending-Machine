defmodule Match_MVP.Repo.Migrations.AddProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :amount_available, :integer, default: 0, null: false
      add :cost, :float, default: 0.00, null: false
      add :product_name, :string
      add :seller_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:products, [:seller_id])
    create unique_index(:products, [:product_name])
  end
end
