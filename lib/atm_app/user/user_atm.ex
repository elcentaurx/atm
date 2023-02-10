defmodule AtmApp.User.UserAtm do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_atm" do
    field :nick_name, :string
    field :balance, :float, default: 0.0

    timestamps()
  end



  @doc false
  def changeset(user_atm, attrs) do
    user_atm
    |> cast(attrs, [:nick_name, :balance])
    |> validate_required([:nick_name, :balance])
    |> unique_constraint([:nick_name])
    |> validate_length(:nick_name, min: 3, max: 255)
    |> validate_number(:balance, greater_than_or_equal_to: 0)
  end





end
