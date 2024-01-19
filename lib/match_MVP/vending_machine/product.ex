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
    |> validate_number(:amount_available, greater_than: 0)
    # |> validate_cost()
  end

  # defp validate_cost(changeset) do
  #   cost = get_field(changeset, :cost)
  #   remainder = rem(cost, 5)

  #   case remainder == 0 do
  #     true -> changeset
  #     _ -> add_error(changeset, :cost, "must be divisible by 5")
  #   end
  # end


  # COME AND FIX THIS IF YOU HAVE TIME

end
