defmodule Casex.MixProject do
  use Mix.Project

  def project do
    [
      app: :casex,
      version: "0.4.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      description: "Simple case conversion for web applications",
      package: package(),
      name: "Casex",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:recase, "~> 0.6"},
      {:jason, "~> 1.2"},
      {:plug, "~> 1.10", optional: true}
    ]
  end

  defp package do
    [
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/brainnco/casex"}
    ]
  end

  defp docs do
    [
      main: "Casex",
      source_url: "https://github.com/brainnco/casex"
    ]
  end
end
