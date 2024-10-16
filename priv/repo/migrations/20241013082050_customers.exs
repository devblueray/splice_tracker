defmodule SpliceTracker.Repo.Migrations.Customers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :customer_name, :string, null: false
      add :customer_address, :string, null: false
    end
  end
end
