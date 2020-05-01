# Casex

![CI](https://github.com/thiamsantos/casex/workflows/CI/badge.svg?branch=master)

Simple case conversion for web applications.
Easily decodes `camelCase` body payloads to `snake_case` and
response payloads from `camelCase` to `snake_case`.
Useful to maintain to expose your API in `camelCase` but keep internally the elixir naming conventions.

It leverages [recase](https://github.com/sobolevn/recase) to provide case conversions
[without relying on the `Macro` module](https://github.com/sobolevn/recase#why) and
easily integrates with [plug](https://hex.pm/packages/plug)-based applications.

## Installation

The package can be installed
by adding `casex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:casex, "~> 0.1.0"}
  ]
end
```

## Usage

The complete docs can be found at [https://hexdocs.pm/casex](https://hexdocs.pm/casex).

## License

Copyright 2020 Thiago Santos.

Casex source code is released under Apache 2 License.

Check [LICENSE](LICENSE) file for more information.
