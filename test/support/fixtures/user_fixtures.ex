defmodule AtmApp.UserFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AtmApp.User` context.
  """

  @doc """
  Generate a user_atm.
  """
  def user_atm_fixture(attrs \\ %{}) do
    {:ok, user_atm} =
      attrs
      |> Enum.into(%{
        balance: 120.5,
        nick_name: "some nick_name"
      })
      |> AtmApp.User.create_user_atm()

    user_atm
  end
end
