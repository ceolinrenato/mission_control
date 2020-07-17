defmodule MissionControl.MixProject do
  use Mix.Project

  def project do
    [
      app: :mission_control,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        plt_add_deps: :apps_tree,
        ignore_warnings: ".dialyzer_ignore.exs",
        list_unused_filters: true,
        # we use the following opt to change the PLT path
        # even though the opt is marked as deprecated, this is the doc-recommended way
        # to do this
        plt_file: {:no_warn, "_dialyzer/innecto.plt"}
      ],
      escript: escript()
    ]
  end

  def escript do
    [main_module: MissionControl]
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
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:mock, "~> 0.3.0", only: :test}
    ]
  end
end
