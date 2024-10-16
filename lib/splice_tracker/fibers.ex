defmodule SpliceTracker.Fibers do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "fibers" do
    field :boxid
    field :color
    field :connection
  end

  def changeset(fiber, params \\ %{}) do
    fiber
    |> cast(params, [:boxid, :color, :connection])
    |> validate_required([:boxid, :color, :connection])
    |> unique_constraint(:boxid)
  end

end
