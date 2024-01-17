defmodule Match_MVP.VendingMachine.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :amount_available, :integer
    field :cost, :float
    field :product_name, :string

    belongs_to :seller, Match_MVP.Accounts.User

    timestamps()
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [:amount_available, :cost, :product_name])
    |> validate_required([:amount_available, :cost, :product_name])
  end
end