defmodule CasexTest do
  use ExUnit.Case
  doctest Casex

  defmodule MyStruct do
    defstruct [:key]
  end

  test "README install version check" do
    app = :casex

    app_version = "#{Application.spec(app, :vsn)}"
    readme = File.read!("README.md")
    [_, readme_versions] = Regex.run(~r/{:#{app}, "(.+)"}/, readme)

    assert Version.match?(app_version, readme_versions)
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
