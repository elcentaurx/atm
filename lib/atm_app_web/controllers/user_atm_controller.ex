defmodule AtmAppWeb.UserAtmController do
  use AtmAppWeb, :controller

  alias AtmApp.User
  alias AtmApp.User.UserAtm

  def index(conn, _params) do
    user_atm = User.list_user_atm()
    json put_status(conn, :ok),  %{users: user_atm
    |> Enum.map(fn f -> %{}
      |> Map.put(:id, f.id)
      |> Map.put(:nick_name, f.nick_name)
      |> Map.put(:balance, f.balance)
      |> Map.put(:inserted_at, f.inserted_at)
      |> Map.put(:updated_at, f.updated_at)
    end)}


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

  def update(conn, %{"id" => id, "user_atm" => user_atm_params, "type" => type}) do
    user_atm = User.get_user_atm!(id)
     if(type == 0) do
      validate_quantity(user_atm.balance, user_atm_params["balance"]) |> case do
        true ->
          User.update_user_atm(user_atm, user_atm_params |> Map.put("balance", user_atm.balance - abs(user_atm_params["balance"])))
          |> case do
            {:ok, _atm_user} ->
              json put_status(conn, :ok), %{"message" => "balance updated successfully" }
            {:error, %Ecto.Changeset{} = changeset} ->
              json put_status(conn, :error), %{"message" => "#{inspect(changeset.errors)}" }
          end
          _->
            json put_status(conn, :ok), %{"message" => "it is not possible to perform the operation" }
      end
     else
      User.update_user_atm(user_atm, user_atm_params |> Map.put("balance", user_atm.balance + abs(user_atm_params["balance"])))
      |> case do
        {:ok, _atm_user} ->
          json put_status(conn, :ok), %{"message" => "balance updated successfully" }
        {:error, %Ecto.Changeset{} = changeset} ->
          json put_status(conn, :error), %{"message" => "#{inspect(changeset.errors)}" }
       end
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

  def get_founds(conn, %{"id" => id}) do
    user_atm = User.get_user_atm!(id)
    json put_status(conn, :ok), %{"message" => user_atm }
  end

  def render_json(response, conn, status) do
    json put_status(conn, status), response
  end

  def validate_quantity(actual_balance, value) do
    aux = actual_balance - abs(value)
      if(aux > 0) do
        true
      else
        false
      end

  end

end
