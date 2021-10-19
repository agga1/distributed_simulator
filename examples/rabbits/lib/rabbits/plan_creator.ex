defmodule Rabbits.PlanCreator do
  use Rabbits.Constants
  use Simulator.PlanCreator

  import Nx.Defn
  import Simulator.Helpers

  @impl true
  defn create_plan(i, j, plans, grid, object_data, iteration) do
    plan =
      cond do
        Nx.equal(grid[i][j][0], @rabbit) ->
          create_plan_rabbit(i, j, grid)

        Nx.equal(grid[i][j][0], @lettuce) ->
          create_plan_lettuce(i, j, grid, iteration)

        :otherwise ->
          create_plan_other(i, j, grid)
      end

    plans = add_plan(plans, i, j, plan)
    {i, j + 1, plans, grid, iteration}
  end

  defnp create_plan_rabbit(i, j, grid) do
    Nx.tensor([@dir_stay, @keep, @keep])
  end

  defnp create_plan_lettuce(i, j, grid, iteration) do
    if Nx.remainder(iteration, @lettuce_growth_factor) |> Nx.equal(Nx.tensor(0)) do
      {_i, _j, _direction, availability, availability_size, _grid} =
        while {i, j, direction = 1, availability = Nx.broadcast(Nx.tensor(0), {8}), curr = 0, grid},
              Nx.less(direction, 9) do
          {x, y} = shift({i, j}, direction)

          if Nx.equal(grid[x][y][0], @empty) do
            availability = Nx.put_slice(availability, [curr], Nx.broadcast(direction, {1}))
            {i, j, direction + 1, availability, curr + 1, grid}
          else
            {i, j, direction + 1, availability, curr, grid}
          end
        end
        # TODO fire in EVACUATION will error when av size == 0
        if availability_size > 0 do
          index = Nx.random_uniform({1}, 0, availability_size, type: {:s, 8})

          # to create [dir, mock, empty] we convert dir (scalar tensor) to tensor of shape [1]
          direction = Nx.reshape(availability[index], {1})
          action_consequence = Nx.tensor([@add_lettuce, @keep])
          Nx.concatenate([direction, action_consequence])
        else
          Nx.tensor([@dir_stay, @keep, @keep])
        end
    else
      Nx.tensor([@dir_stay, @keep, @keep])
    end
  end

  defnp create_plan_other(_i, _j, _grid) do
    Nx.tensor([@dir_stay, @keep, @keep])
  end

  defnp add_plan(plans, i, j, plan) do
    Nx.put_slice(plans, [i, j, 0], Nx.broadcast(plan, {1, 1, 3}))
  end
end
