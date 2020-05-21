defmodule Casex.MySerializableStruct do
  defstruct [:cool_key]

  defimpl Casex.Serializable do
    def serialize(data), do: Map.take(data, [:cool_key])
  end
end

defmodule Casex.MyStruct do
  defstruct [:cool_key]
end

defmodule Casex.MyStructDerived do
  @derive Casex.Serializable

  defstruct [:cool_key, :another_key]
end

defmodule Casex.MyStructDerivedWithOnly do
  @derive {Casex.Serializable, only: [:cool_key]}

  defstruct [:cool_key, :another_key]
end

defmodule Casex.MyStructDerivedWithExcept do
  @derive {Casex.Serializable, except: [:cool_key]}

  defstruct [:cool_key, :another_key]
end
