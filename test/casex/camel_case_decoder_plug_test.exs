defmodule Casex.CamelCaseDecoderPlugTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Casex.CamelCaseDecoderPlug

  describe "call/2" do
    test "decodes params" do
      opts = CamelCaseDecoderPlug.init([])

      body = %{
        "user" => %{
          "firstName" => "Han",
          "lastName" => "Solo",
          "alliesInCombat" => [
            %{"name" => "Luke", "weaponOfChoice" => "lightsaber"},
            %{"name" => "Chewie", "weaponOfChoice" => "bowcaster"},
            %{"name" => "Leia", "weaponOfChoice" => "blaster"}
          ]
        }
      }

      conn = conn(:get, "/hello", body)

      conn = CamelCaseDecoderPlug.call(conn, opts)

      assert conn.params == %{
               "user" => %{
                 "allies_in_combat" => [
                   %{"name" => "Luke", "weapon_of_choice" => "lightsaber"},
                   %{"name" => "Chewie", "weapon_of_choice" => "bowcaster"},
                   %{"name" => "Leia", "weapon_of_choice" => "blaster"}
                 ],
                 "first_name" => "Han",
                 "last_name" => "Solo"
               }
             }
    end
  end
end
