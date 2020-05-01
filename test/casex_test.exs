defmodule CasexTest do
  use ExUnit.Case
  doctest Casex

  defmodule MyStruct do
    defstruct [:key]
  end

  describe "to_camel_case/1" do
    test "struct" do
      my_struct = %MyStruct{key: "value"}

      assert Casex.to_camel_case(my_struct) == my_struct
    end
  end

  describe "to_snake_case/1" do
    test "struct" do
      my_struct = %MyStruct{key: "value"}

      assert Casex.to_snake_case(my_struct) == my_struct
    end
  end
end
