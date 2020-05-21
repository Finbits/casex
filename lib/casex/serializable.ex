defprotocol Casex.Serializable do
  @moduledoc """
  Protocol controlling how a value is serialized. It is useful to handle custom
  structs of your app, without that the `Casex` will be skipped and passed directly to Jason.

  ## Deriving

  The protocol allows leveraging the Elixir's `@derive` feature
  to simplify protocol implementation in trivial cases. Accepted
  options are:

    * `:only` - encodes only values of specified keys.
    * `:except` - encodes all struct fields except specified keys.

  By default all keys except the `:__struct__` key are serialized.

  ## Example

  Let's assume a presence of the following struct:

      defmodule Test do
        defstruct [:foo, :bar, :baz]
      end

  If we were to call `@derive Casex.Serializable` just before `defstruct`,
  an implementation similar to the following implementation would be generated:

      defimpl Casex.Serializable, for: Test do
        def serialize(data) do
          Map.take(data, [:foo, :bar, :baz])
        end
      end

  If we called `@derive {Casex.Serializable, only: [:foo]}`, an implementation
  similar to the following implementation would be generated:

      defimpl Casex.Serializable, for: Test do
        def serialize(data) do
          Map.take(data, [:foo])
        end
      end

  If we called `@derive {Casex.Serializable, except: [:foo]}`, an implementation
  similar to the following implementation would be generated:

      defimpl Casex.Serializable, for: Test do
        def serialize(data) do
          Map.take(data, [:bar, :baz])
        end
      end

  """

  @fallback_to_any true
  def serialize(data)
end

defimpl Casex.Serializable, for: Any do
  defmacro __deriving__(module, struct, options) do
    fields = fields_to_encode(struct, options)

    quote do
      defimpl Casex.Serializable, for: unquote(module) do
        def serialize(data) do
          Map.take(data, unquote(fields))
        end
      end
    end
  end

  def serialize(data), do: data

  defp fields_to_encode(struct, opts) do
    cond do
      only = Keyword.get(opts, :only) ->
        only

      except = Keyword.get(opts, :except) ->
        Map.keys(struct) -- [:__struct__ | except]

      true ->
        Map.keys(struct) -- [:__struct__]
    end
  end
end
