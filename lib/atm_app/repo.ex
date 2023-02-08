defmodule AtmApp.Repo do
  use Ecto.Repo,
    otp_app: :atm_app,
    adapter: Ecto.Adapters.Postgres
end
