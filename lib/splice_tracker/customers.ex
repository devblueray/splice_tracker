defmodule SpliceTracker.Customers do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "customers" do
    field :customer_name
    field :customer_address
  end

  def changeset(customers, params \\ %{}) do
    customers
    |> cast(params, [:customer_name, :customer_address])
    |> validate_required([:customer_name, :customer_address])
    |> unique_constraint(:customer_address)
  end

end
