defmodule Match_MVP.VendingMachine.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :basket, {:array, :map}
    field :total_cost, :float

    belongs_to :user, Match_MVP.Accounts.User

    timestamps()
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [:basket, :total_cost])
    |> validate_required([:basket, :total_cost])
  end
end
