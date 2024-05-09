defmodule AppBasic.Repo do
  use Ecto.Repo,
    otp_app: :app_basic,
    adapter: Ecto.Adapters.Postgres
end
