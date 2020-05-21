defmodule Casex.CamelCaseEncoder do
  @moduledoc """
  Format encoder for phoenix. Converts all the keys of the json data to camel case.

  ## Usage

  Add `Casex.CamelCaseEncoder` as json format encoder for phoenix:

  ```
  # config.exs
  config :phoenix, :format_encoders, json: Casex.CamelCaseEncoder
  ```

  Now all outcoming json response bodies will be converted to camel case.

  ## Structs

  If you want to control how the keys will be serilized before been encoded by `Jason`,
  you can provide a implementation for the `Casex.Serializable` protocol, by default it
  will return the structs as they come, without any transformation.

  """

  @spec encode_to_iodata!(data :: term()) :: iodata() | no_return()
  def encode_to_iodata!(data) do
    data
    |> Casex.to_camel_case()
    |> Jason.encode_to_iodata!()
  end
end
