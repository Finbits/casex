defmodule Casex do
  @moduledoc """
  Simple case conversion for web applications.
  Easily decodes `camelCase` body payloads to `snake_case` and
  response payloads from `camelCase` to `snake_case`.
  Useful to maintain to expose your API in `camelCase` but keep internally the elixir naming conventions.

  It leverages [recase](https://github.com/sobolevn/recase) to provide case conversions
  without relying on the `Macro` module and
  easily integrates with [plug](https://hex.pm/packages/plug)-based applications.

  ## Phoenix Integration

  1. Add `Casex.CamelCaseDecoderPlug` to your api pipeline:

  ```elixir
  # router.ex
  pipeline :api do
    plug :accepts, ["json"]
    plug Casex.CamelCaseDecoderPlug
  end
  ```
  Now, all request bodies and params will be converted to snake case.


  2. Add `Casex.CamelCaseEncoder` as json format encoder for phoenix:

  ```elixir
  # config.exs
  config :phoenix, :format_encoders, json: Casex.CamelCaseEncoder
  ```

  Now all outcoming json response bodies will be converted to camel case.
  """

  alias Casex.Serializable

  @doc """
  Converts all keys of a map to snake case.
  If the map is a struct with no `Enumerable` implementation the value is returned without convertion.

  ## Examples

      iex> data = %{
      ...>   "user" => %{
      ...>     "firstName" => "James",
      ...>     "lastName" => "Kirk",
      ...>     "crew" => [
      ...>       %{"name" => "Spock", "serialNumber" => "S 179-276 SP"},
      ...>       %{"name" => "Scotty", "serialNumber" => "SE 19754 T"}
      ...>     ]
      ...>   }
      ...> }
      iex> Casex.to_snake_case(data)
      %{
        "user" => %{
          "first_name" => "James",
          "last_name" => "Kirk",
          "crew" => [
            %{"name" => "Spock", "serial_number" => "S 179-276 SP"},
            %{"name" => "Scotty", "serial_number" => "SE 19754 T"}
          ]
        }
      }

  """
  @spec to_snake_case(data :: term()) :: term()
  def to_snake_case(data) when is_map(data) do
    data
    |> Enum.map(fn {key, value} -> {snake_case(key), to_snake_case(value)} end)
    |> Enum.into(%{})
  rescue
    Protocol.UndefinedError -> data
  end

  def to_snake_case(data) when is_list(data) do
    Enum.map(data, &to_snake_case/1)
  end

  def to_snake_case(data), do: data

  defp snake_case(value) when is_atom(value) do
    value
    |> to_string()
    |> snake_case()
  end

  defp snake_case(value) when is_binary(value) do
    Recase.to_snake(value)
  end

  @doc """
  Converts all keys of a map to camel case.
  If the map is a struct with no `Enumerable` implementation the value is returned without convertion.

  ## Examples

      iex> data = %{
      ...>   user: %{
      ...>     first_name: "James",
      ...>     last_name: "Kirk",
      ...>     crew: [
      ...>       %{name: "Spock", serial_number: "S 179-276 SP"},
      ...>       %{name: "Scotty", serial_number: "SE 19754 T"}
      ...>     ]
      ...>   }
      ...> }
      iex> Casex.to_camel_case(data)
      %{
        "user" => %{
          "firstName" => "James",
          "lastName" => "Kirk",
          "crew" => [
            %{"name" => "Spock", "serialNumber" => "S 179-276 SP"},
            %{"name" => "Scotty", "serialNumber" => "SE 19754 T"}
          ]
        }
      }

  """
  @spec to_camel_case(data :: term()) :: term()
  def to_camel_case(data) when is_map(data) do
    result = Serializable.serialize(data)

    case result do
      {map, dict} ->
        map
        |> Enum.map(fn {key, value} ->
          {Map.get_lazy(dict, key, fn -> camel_case(key) end), to_camel_case(value)}
        end)
        |> Enum.into(%{})

      map ->
        map
        |> Enum.map(fn {key, value} -> {camel_case(key), to_camel_case(value)} end)
        |> Enum.into(%{})
    end
  rescue
    Protocol.UndefinedError -> data
  end

  def to_camel_case(data) when is_list(data) do
    Enum.map(data, &to_camel_case/1)
  end

  def to_camel_case(data), do: Serializable.serialize(data)

  defp camel_case(value) when is_atom(value) do
    value
    |> to_string()
    |> camel_case()
  end

  defp camel_case(value) when is_binary(value) do
    Recase.to_camel(value)
  end
end
