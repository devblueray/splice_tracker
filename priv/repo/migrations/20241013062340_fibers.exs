defmodule SpliceTracker.Repo.Migrations.Fibers do
  use Ecto.Migration

  def change do
    create table (:fibers) do
      add :boxid, :string, null: false
      add :color, :string, null: false
      add :connection, :string, null: true
    end

  end
end
