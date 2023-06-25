defmodule Trackdays.Repo do
  use Ecto.Repo,
    otp_app: :trackdays,
    adapter: Ecto.Adapters.Postgres
end
