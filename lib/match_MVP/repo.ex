defmodule Match_MVP.Repo do
  use Ecto.Repo,
    otp_app: :match_MVP,
    adapter: Ecto.Adapters.Postgres
end
