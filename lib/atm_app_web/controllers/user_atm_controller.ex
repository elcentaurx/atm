defmodule AtmAppWeb.UserAtmController do
  use AtmAppWeb, :controller

  alias AtmApp.User
  alias AtmApp.User.UserAtm

  def index(conn, _params) do
    user_atm = User.list_user_atm()
    json put_status(conn, :ok), %{"users" => "#{user_atm}"}
  end

  def new(conn, _params) do
    changeset = User.change_user_atm(%UserAtm{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user_atm" => user_atm_params}) do
    case User.create_user_atm(user_atm_params) do
      {:ok, _user_atm} ->
       json put_status(conn, :ok), %{"message" => "user created successfully" }

      {:error, %Ecto.Changeset{} = changeset} ->
        json put_status(conn, :error), %{"message" => "#{inspect(changeset.errors)}" }
    end
  end

  def show(conn, %{"id" => id}) do
    user_atm = User.get_user_atm!(id)
    json put_status(conn, :ok), %{"message" => "#{user_atm}" }
  end

  def edit(conn, %{"id" => id}) do
    user_atm = User.get_user_atm!(id)
    changeset = User.change_user_atm(user_atm)
    render(conn, "edit.html", user_atm: user_atm, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user_atm" => user_atm_params}) do
    user_atm = User.get_user_atm!(id)

    case User.update_user_atm(user_atm, user_atm_params) do
      {:ok, _atm_user} ->
        json put_status(conn, :ok), %{"message" => "user updated successfully" }
      {:error, %Ecto.Changeset{} = changeset} ->
        json put_status(conn, :error), %{"message" => "#{inspect(changeset.errors)}" }
    end
  end

  def delete(conn, %{"id" => id}) do
    user_atm = User.get_user_atm!(id)
    case User.delete_user_atm(user_atm) do
      {:ok, _atm_user} ->
        json put_status(conn, :ok), %{"message" => "user deleted successfully" }
      {:error, %Ecto.Changeset{} = changeset} ->
        json put_status(conn, :error), %{"message" => "#{inspect(changeset.errors)}" }
    end
  end

  def balance(conn, %{"id" => id})  do
    user_atm = User.get_user_atm!(id)
    case User.delete_user_atm(user_atm) do
      {:ok, _atm_user} ->
        json put_status(conn, :ok), %{"message" => "user deleted successfully" }
      {:error, %Ecto.Changeset{} = changeset} ->
        json put_status(conn, :error), %{"message" => "#{inspect(changeset.errors)}" }
    end
  end
end
