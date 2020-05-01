if Code.ensure_loaded?(Plug) do
  defmodule Casex.CamelCaseDecoderPlug do
    @moduledoc """
    Converts all plug params to snake case.

    ## Usage

    Add `Casex.CamelCaseDecoderPlug` to your api pipeline:

    ```elixir
    # router.ex
    pipeline :api do
      plug :accepts, ["json"]
      plug Casex.CamelCaseDecoderPlug
    end
    ```

    Now, all request bodies and params will be converted to snake case.
    """
    @behaviour Plug

    @impl Plug
    def init(opts), do: opts

    @impl Plug
    def call(conn, _opts) do
      %{conn | params: Casex.to_snake_case(conn.params)}
    end
  end
end
