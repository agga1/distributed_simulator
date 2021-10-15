defmodule Simulator.PlanResolver do
  @moduledoc """
  Module which should be `used` by exactly one module in every
  simulation. That module will be called PlanResolver module.

  Using module have to implement two functions:
  - `is_update_valid?/2` - which will be responsible for checking
    whether the `action` can be applied to the `object`;
  - `apply_update/5` - which should return the `grid` with applied
    `action` on the `grid[x][y]`.

  See `Evacuation.PlanResolver` in the `examples` directory for
  the exemplary usage.
  """

  alias Simulator.Types

  @callback is_update_valid?(action :: Nx.t(), object :: Nx.t()) :: Nx.t()
  @callback apply_update(
              grid :: Nx.t(),
              x :: Types.index(),
              y :: Types.index(),
              action :: Nx.t(),
              object :: Nx.t()
            ) :: Nx.t()

  defmacro __using__(_opts) do
    quote location: :keep do
      @behaviour unquote(__MODULE__)
    end
  end
end
