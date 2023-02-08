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
    |> unique_constraint(:nick_name)



    # |> validate_length(:nick_name, min: 6, max: 6)
    # |> validate_number(:balance, [greater_than_or_equal_to: 0, less_than_or_equal_to: 10000])
    # |> validate_format(:nick_name, ~r/^[A-Za-z0-9]*$/, message: "must have only numbers and letters, 6 characters of length")
  end





end
