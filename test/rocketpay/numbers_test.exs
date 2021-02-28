defmodule Rocketpay.NumbersTest do
  use ExUnit.Case, async: true

  alias Rocketpay.Numbers

  describe("sum_from_file/1") do
    test "when the file exists returns the sum of its content" do
      response = Numbers.sum_from_file("numbers")

      expected_response = {:ok, %{result: 37}}

      assert response == expected_response
    end

    test "when the file does not exist returns an error" do
      response = Numbers.sum_from_file("banana")

      expected_response = {:error, %{message: "File does not exist"}}

      assert response == expected_response
    end
  end
end
