defmodule AtmApp.User do
  alias AtmApp.User.Queries.BalanceQuery
  @moduledoc """
  The User context.
  """

  import Ecto.Query, warn: false
  alias AtmApp.User.Queries.BalanceQuery
  alias AtmApp.Repo

  alias AtmApp.User.UserAtm

  @doc """
  Returns the list of user_atm.

  ## Examples

      iex> list_user_atm()
      [%UserAtm{}, ...]

  """
  def list_user_atm do
    Repo.all(UserAtm)
  end

  @doc """
  Gets a single user_atm.

  Raises `Ecto.NoResultsError` if the User atm does not exist.

  ## Examples

      iex> get_user_atm!(123)
      %UserAtm{}

      iex> get_user_atm!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_atm!(id), do: Repo.get!(UserAtm, id)

  @doc """
  Creates a user_atm.

  ## Examples

      iex> create_user_atm(%{field: value})
      {:ok, %UserAtm{}}

      iex> create_user_atm(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_atm(attrs \\ %{}) do
    %UserAtm{}
    |> UserAtm.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_atm.

  ## Examples

      iex> update_user_atm(user_atm, %{field: new_value})
      {:ok, %UserAtm{}}

      iex> update_user_atm(user_atm, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_atm(%UserAtm{} = user_atm, attrs) do
    user_atm
    |> UserAtm.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_atm.

  ## Examples

      iex> delete_user_atm(user_atm)
      {:ok, %UserAtm{}}

      iex> delete_user_atm(user_atm)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_atm(%UserAtm{} = user_atm) do
    Repo.delete(user_atm)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_atm changes.

  ## Examples

      iex> change_user_atm(user_atm)
      %Ecto.Changeset{data: %UserAtm{}}

  """
  def change_user_atm(%UserAtm{} = user_atm, attrs \\ %{}) do
    UserAtm.changeset(user_atm, attrs)
  end

  def get_balance(id) do
    BalanceQuery.get_balance(id) |> Repo.one()
  end

end
