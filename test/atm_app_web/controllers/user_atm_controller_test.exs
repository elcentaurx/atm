defmodule AtmAppWeb.UserAtmControllerTest do
  use AtmAppWeb.ConnCase

  import AtmApp.UserFixtures

  @create_attrs %{balance: 120.5, nick_name: "some nick_name"}
  @update_attrs %{balance: 456.7, nick_name: "some updated nick_name"}
  @invalid_attrs %{balance: nil, nick_name: nil}

  describe "index" do
    test "lists all user_atm", %{conn: conn} do
      conn = get(conn, Routes.user_atm_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing User atm"
    end
  end

  describe "new user_atm" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_atm_path(conn, :new))
      assert html_response(conn, 200) =~ "New User atm"
    end
  end

  describe "create user_atm" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_atm_path(conn, :create), user_atm: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.user_atm_path(conn, :show, id)

      conn = get(conn, Routes.user_atm_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show User atm"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_atm_path(conn, :create), user_atm: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User atm"
    end
  end

  describe "edit user_atm" do
    setup [:create_user_atm]

    test "renders form for editing chosen user_atm", %{conn: conn, user_atm: user_atm} do
      conn = get(conn, Routes.user_atm_path(conn, :edit, user_atm))
      assert html_response(conn, 200) =~ "Edit User atm"
    end
  end

  describe "update user_atm" do
    setup [:create_user_atm]

    test "redirects when data is valid", %{conn: conn, user_atm: user_atm} do
      conn = put(conn, Routes.user_atm_path(conn, :update, user_atm), user_atm: @update_attrs)
      assert redirected_to(conn) == Routes.user_atm_path(conn, :show, user_atm)

      conn = get(conn, Routes.user_atm_path(conn, :show, user_atm))
      assert html_response(conn, 200) =~ "some updated nick_name"
    end

    test "renders errors when data is invalid", %{conn: conn, user_atm: user_atm} do
      conn = put(conn, Routes.user_atm_path(conn, :update, user_atm), user_atm: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User atm"
    end
  end

  describe "delete user_atm" do
    setup [:create_user_atm]

    test "deletes chosen user_atm", %{conn: conn, user_atm: user_atm} do
      conn = delete(conn, Routes.user_atm_path(conn, :delete, user_atm))
      assert redirected_to(conn) == Routes.user_atm_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_atm_path(conn, :show, user_atm))
      end
    end
  end

  defp create_user_atm(_) do
    user_atm = user_atm_fixture()
    %{user_atm: user_atm}
  end
end
