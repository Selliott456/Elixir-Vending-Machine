defmodule Match_MVP.Products do
  alias Match_MVP.Repo
  import Ecto.Query, warn: false

  alias Match_MVP.Products.Product

  def list_products() do
    Repo.all(Product)
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
end
