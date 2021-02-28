defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.Users.Create
  alias Rocketpay.User

  describe "call/1" do
    test "when all parameters are valid, returns an user" do
      params = %{
        name: "Teste",
        password: "123456",
        nickname: "teste",
        email: "teste@teste.com",
        age: 18
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)

      assert %User{name: "Teste", age: 18, id: ^user_id} = user
    end

    test "when there are invalid parameters, returns an error" do
      params = %{
        name: "Teste",
        password: "",
        nickname: "teste",
        email: "teste@teste.com",
        age: 15
      }

      {:error, changeset} = Create.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["can't be blank"]
      }

      assert errors_on(changeset) == expected_response
    end
  end
end
