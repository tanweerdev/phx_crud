defmodule PhxCrud.MixProject do
  use Mix.Project

  def project do
    [
      app: :phx_crud,
      version: "0.1.1",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      deps: deps(),
      name: "PhxCrud",
      description: description(),
      package: package(),
      docs: [
        # The main page in the docs
        main: "readme",
        # logo: "path/to/logo.png",
        extras: ["README.md"]
      ],
      source_url: "https://github.com/tanweerdev/phx_crud"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:earmark, "~> 1.2", only: :dev}
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  defp description() do
    "phx_crud provides standard macros for common phoenix crud operations"
  end

  defp package() do
    [
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README*),
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/tanweerdev/phx_crud",
        "Docs" => "https://hexdocs.pm/phx_crud/"
      }
    ]
  end
end
