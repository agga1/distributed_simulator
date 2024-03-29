defmodule Evacuation.MixProject do
  use Mix.Project

  def project do
    [
      app: :evacuation,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
    if System.user_home() == "/Users/samuelheldak" do
      [
        {:nx, path: "/Users/samuelheldak/studies/nx/nx", override: true},
        {:distributed_simulator,
         path: "/Users/samuelheldak/studies/distributed_simulator",},
         {:exla, path: "/Users/samuelheldak/studies/nx/exla", override: true}
      ]
    else
      [
        {:nx, path: "/Users/agnieszkadutka/repos/inz/nx/nx", override: true},
        {:distributed_simulator,
        path: "/Users/agnieszkadutka/repos/inz/distributed_simulator", override: true}
      ]
    end
  end
end
