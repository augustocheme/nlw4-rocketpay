defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Teste",
        password: "123456",
        nickname: "teste",
        email: "teste@teste.com",
        age: 18
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic cm9vdDpyb290")

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all parameters are valid, make a deposit", %{conn: conn, account_id: account_id} do
      params = %{
        "value" => "50.00"
      }

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)

      assert %{
               "account" => %{"balance" => "50.00", "id" => _id},
               "message" => "Account updated"
             } = response
    end

    test "when there are invalid parameters, return an error", %{
      conn: conn,
      account_id: account_id
    } do
      params = %{
        "value" => "blablabla"
      }

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid deposit amount"}

      assert response == expected_response
    end
  end
end
