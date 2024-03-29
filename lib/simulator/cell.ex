defmodule Simulator.Cell do
  @moduledoc """
  Module which should be `used` by exactly one module in every
  simulation. That module will be called Cell module.

  Using module have to implement two functions:
  - `generate_signal/1` - for given object returns signal that it
    generates;
  - `signal_factor/1` - for given object returns signal factor -
    value by which the signal is multiplied when encounters that
    object.

  See `Evacuation.Cell` in the `examples` directory for
  the exemplary usage.
  """

  @callback generate_signal(object :: Nx.t()) :: non_neg_integer()
  @callback signal_factor(object :: Nx.t()) :: non_neg_integer()

  defmacro __using__(_opts) do
    quote location: :keep do
      @behaviour unquote(__MODULE__)
    end
  end
end
