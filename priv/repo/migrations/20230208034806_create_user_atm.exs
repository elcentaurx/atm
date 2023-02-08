defmodule AtmApp.Repo.Migrations.CreateUserAtm do
  use Ecto.Migration

  def change do
    create table(:user_atm) do
      add :nick_name, :string
      add :balance, :float

      timestamps()
    end
  end
end
