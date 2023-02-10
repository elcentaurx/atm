defmodule AtmAppWeb.UserAtmController do
  use AtmAppWeb, :controller
  alias AtmApp.User

  @doc """
  Returns the list of users.

  ## Api use

      GET /api/index HTTP/1.1
      Host: localhost:4000

      Response:
      {
      "users": [
        {
          "balance": 10.0,
          "id": 8,
          "inserted_at": "2023-02-10T05:02:28",
          "nick_name": "exampl",
          "updated_at": "2023-02-10T05:02:28"
        },...]
      }
      Returns an empty list if there are no users in the db

  """
  def index(conn, _params) do
    user_atm = User.list_user_atm()
    case user_atm do
      [] ->
        render_json(%{users: []}, conn, conn.status)
      _ ->
        render_json(%{users: user_atm
          |> Enum.map(fn f -> %{}
          |> Map.put(:id, f.id)
          |> Map.put(:nick_name, f.nick_name)
          |> Map.put(:balance, f.balance)
          |> Map.put(:inserted_at, f.inserted_at)
          |> Map.put(:updated_at, f.updated_at)
        end)}, conn, conn.status)
    end
  end

  @doc """
  Create an user .

  ## Api use

    POST /api/create HTTP/1.1
    Content-Type: application/json
    Host: localhost:4000
    Content-Length: 62

    {
      "user_atm": {
        "nick_name": "sixsix",
        "balance": 20
      }
    }

  returns a success message if the structure is correct or an error message if it is not

  """

  def create(conn, %{"user_atm" => user_atm_params}) do
    case User.create_user_atm(user_atm_params) do
      {:ok, _user_atm} ->
        render_json(%{"ok" => "user #{user_atm_params["nick_name"]} created successfully"}, conn, conn.status)
      {:error, %Ecto.Changeset{} = changeset} ->
        render_json(%{"error" => "#{inspect(changeset.errors)}"}, conn, conn.status)
    end
  end

  @doc """
  Update the balance of user.

  ## Api use

    PUT /api/update HTTP/1.1
    Content-Type: application/json
    Host: localhost:4000
    Content-Length: 63

    {
      "id": 1,
      "user_atm": {
        "amount": 2.0
      },
      "type": false
    }


  It is necessary to indicate the user id and the amount you want to deposit/withdraw,
  the type parameter indicates which operation will be deposited/withdrawn,
    type == true -> withdrawal
    _something -> deposit
  the absolute value of the amount is taken

  returns a success message if the transaction was successful and an error message if it was not successful

  """
  def update(conn, %{"id" => id, "user_atm" => user_atm_params, "type" => type}) do
    try do
      user_atm = User.get_user_atm!(id)
      if(type == true) do
       validate_quantity(user_atm.balance, user_atm_params["amount"]) |> case do
         true ->
           User.update_user_atm(user_atm, user_atm_params |> Map.put("balance", user_atm.balance - abs(user_atm_params["amount"])))
           |> case do
             {:ok, _atm_user} ->
               json put_status(conn, :ok), %{"ok" => "you successfully withdrew $#{abs(user_atm_params["amount"])} from your account" }
             {:error, %Ecto.Changeset{} = changeset} ->
               json put_status(conn, :error), %{"error" => "#{inspect(changeset.errors)}" }
           end
           _->
             json put_status(conn, :ok), %{"error" => "insufficient balance" }
       end
      else
       User.update_user_atm(user_atm, user_atm_params |> Map.put("balance", user_atm.balance + abs(user_atm_params["amount"])))
       |> case do
         {:ok, _atm_user} ->
           json put_status(conn, :ok), %{"ok" => "you deposited $#{abs(user_atm_params["amount"])} to your account" }
         {:error, %Ecto.Changeset{} = changeset} ->
           json put_status(conn, :error), %{"error" => "#{inspect(changeset.errors)}" }
        end
     end
    rescue
      Ecto.NoResultsError ->
        render_json(%{"error" => "No result found"}, conn, conn.status)
    end
  end

    @doc """
  Delete an user .

  ## Api use

    DELETE /api/delete HTTP/1.1
    Content-Type: application/json
    Host: localhost:4000
    Content-Length: 14

    {
    "id": "10"
    }

    Delete a user, it is necessary to provide the user's id.
    It returns a success message if it was achieved and an error message if it was not.
  """

  def delete(conn, %{"id" => id}) do
    try do
      user_atm = User.get_user_atm!(id)
      case User.delete_user_atm(user_atm) do
        {:ok, _atm_user} ->
          render_json(%{"ok" => "user deleted successfully"}, conn, conn.status)
        {:error, %Ecto.Changeset{} = changeset} ->
          render_json(%{"error" => "#{inspect(changeset.errors)}"}, conn, conn.status)
      end
    rescue
      Ecto.NoResultsError ->
        render_json(%{"error" => "No result found"}, conn, conn.status)
    end
  end


    @doc """
   Get balance of user.

  ## Api use

    GET /api/founds?id=10 HTTP/1.1
    Content-Type: application/json
    Host: localhost:4000

    Gets the balance of a user, it is necessary to send the id of the user as query_params .
    returns balance if the query was successful and an error if it was not
    """

  def get_founds(conn, _) do
    id = conn.query_params |> Map.get("id")
    case id do
      nil ->  render_json(%{"error" => "user_not found"}, conn, conn.status)
      _ ->
        try do
          user = User.get_user_atm!(id)
            render_json(%{"balance" => user.balance}, conn, conn.status)
        rescue
          Ecto.NoResultsError ->
            render_json(%{"error" => "No user with id: #{id} found"}, conn, conn.status)
        end

    end
  end

  def render_json(response, conn, status) do
    json put_status(conn, status), response
  end
  @doc """
   Validates the substraction of 2 numbers.

  ## Use
     iex> validate_quantity(number_1, number_2)

    Function that returns true if the result of the subtraction of a number minus the absolute of the other number is greater than zero
    """
  def validate_quantity(actual_balance, value) do
    aux = actual_balance - abs(value)
      if(aux > 0) do
        true
      else
        false
      end
  end

end
