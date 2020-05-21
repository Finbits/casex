defmodule CasexTest do
  use ExUnit.Case, async: true

  alias Casex.{
    MyStruct,
    MyStructDerived,
    MyStructDerivedWithOnly,
    MyStructDerivedWithExcept,
    MySerializableStruct
  }

  doctest Casex

  test "README install version check" do
    app = :casex

    app_version = "#{Application.spec(app, :vsn)}"
    readme = File.read!("README.md")
    [_, readme_versions] = Regex.run(~r/{:#{app}, "(.+)"}/, readme)

    assert Version.match?(app_version, readme_versions)
  end

  describe "to_camel_case/1" do
    test "struct" do
      my_struct = %MyStruct{cool_key: "value"}

      assert Casex.to_camel_case(my_struct) == my_struct
    end

    test "seriazable struct" do
      my_struct = %MySerializableStruct{cool_key: "value"}

      assert Casex.to_camel_case(my_struct) == %{"coolKey" => "value"}
    end

    test "derived struct" do
      my_struct = %MyStructDerived{cool_key: "value", another_key: "another"}

      assert Casex.to_camel_case(my_struct) == %{"coolKey" => "value", "anotherKey" => "another"}
    end

    test "derived struct with only" do
      my_struct = %MyStructDerivedWithOnly{cool_key: "value", another_key: "another"}

      assert Casex.to_camel_case(my_struct) == %{"coolKey" => "value"}
    end

    test "derived struct with except" do
      my_struct = %MyStructDerivedWithExcept{cool_key: "value", another_key: "another"}

      assert Casex.to_camel_case(my_struct) == %{"anotherKey" => "another"}
    end
  end

  describe "to_snake_case/1" do
    test "struct" do
      my_struct = %MyStruct{cool_key: "value"}

      assert Casex.to_snake_case(my_struct) == my_struct
    end
  end
end
