defmodule Match_MVP.Orders do
  alias Match_MVP.Repo
  import Ecto.Query, warn: false

  alias Match_MVP.VendingMachine.Order
  def get_order_by_id(id), do: Repo.get!(Order, id)

  def get_order_by_user_id(user_id) do
    Order
    |> where([u], u.user_id == ^user_id)
    |> Repo.one!()
  end

  def create_order(user_id, attrs) do
    %Order{user_id: user_id}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end
end
