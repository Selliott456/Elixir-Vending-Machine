defmodule Match_MVP.Products do
  alias Match_MVP.Repo
  import Ecto.Query, warn: false

  alias Match_MVP.VendingMachine.Product

  def list_products() do
    Product
    |> order_by([p], desc: p.inserted_at)
    |> Repo.all()
  end

  def get_product_by_id!(id), do: Repo.get!(Product, id)

  def create_product(seller_id, attrs \\ %{}) do
    %Product{seller_id: seller_id}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  def change_product_registration(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  def get_products_by_seller_id(seller_id) do
    Product
    |> where([p], p.seller_id == ^seller_id)
    |> Repo.all()
  end
end
