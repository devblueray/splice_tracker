defmodule SpliceTracker.Repo do
  use Ecto.Repo,
    otp_app: :splice_tracker,
    adapter: Ecto.Adapters.Postgres
end
