defmodule AtmApp.UserTest do
  use AtmApp.DataCase

  alias AtmApp.User

  describe "user_atm" do
    alias AtmApp.User.UserAtm

    import AtmApp.UserFixtures

    @invalid_attrs %{balance: nil, nick_name: nil}

    test "list_user_atm/0 returns all user_atm" do
      user_atm = user_atm_fixture()
      assert User.list_user_atm() == [user_atm]
    end

    test "get_user_atm!/1 returns the user_atm with given id" do
      user_atm = user_atm_fixture()
      assert User.get_user_atm!(user_atm.id) == user_atm
    end

    test "create_user_atm/1 with valid data creates a user_atm" do
      valid_attrs = %{balance: 120.5, nick_name: "some nick_name"}

      assert {:ok, %UserAtm{} = user_atm} = User.create_user_atm(valid_attrs)
      assert user_atm.balance == 120.5
      assert user_atm.nick_name == "some nick_name"
    end

    test "create_user_atm/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = User.create_user_atm(@invalid_attrs)
    end

    test "update_user_atm/2 with valid data updates the user_atm" do
      user_atm = user_atm_fixture()
      update_attrs = %{balance: 456.7, nick_name: "some updated nick_name"}

      assert {:ok, %UserAtm{} = user_atm} = User.update_user_atm(user_atm, update_attrs)
      assert user_atm.balance == 456.7
      assert user_atm.nick_name == "some updated nick_name"
    end

    test "update_user_atm/2 with invalid data returns error changeset" do
      user_atm = user_atm_fixture()
      assert {:error, %Ecto.Changeset{}} = User.update_user_atm(user_atm, @invalid_attrs)
      assert user_atm == User.get_user_atm!(user_atm.id)
    end

    test "delete_user_atm/1 deletes the user_atm" do
      user_atm = user_atm_fixture()
      assert {:ok, %UserAtm{}} = User.delete_user_atm(user_atm)
      assert_raise Ecto.NoResultsError, fn -> User.get_user_atm!(user_atm.id) end
    end

    test "change_user_atm/1 returns a user_atm changeset" do
      user_atm = user_atm_fixture()
      assert %Ecto.Changeset{} = User.change_user_atm(user_atm)
    end
  end
end
