defmodule Casex.CamelCaseEncoderTest do
  use ExUnit.Case, async: true

  alias Casex.CamelCaseEncoder

  describe "encode_to_iodata!/1" do
    test "transforms payload to camel case" do
      data = %{
        user: %{
          first_name: "James",
          last_name: "Kirk",
          crew: [
            %{name: "Spock", serial_number: "S 179-276 SP"},
            %{name: "Scotty", serial_number: "SE 19754 T"}
          ]
        }
      }

      expected_data = %{
        "user" => %{
          "firstName" => "James",
          "lastName" => "Kirk",
          "crew" => [
            %{"name" => "Spock", "serialNumber" => "S 179-276 SP"},
            %{"name" => "Scotty", "serialNumber" => "SE 19754 T"}
          ]
        }
      }

      result = CamelCaseEncoder.encode_to_iodata!(data)

      assert Jason.decode!(result) == expected_data
    end
  end
end
