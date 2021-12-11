defmodule Aoc2021.Day11 do
  import Aoc2021.Helpers
  alias :array, as: Array

  @doc """
    iex> Aoc2021.Day11.p1("inputs/day11.txt")
    1655
  """

  def p1(file) do
    grid = parse(file)
    state = OctopiState.new(grid)

    state = Enum.reduce(0..99, state, fn _, acc -> update_energy(acc) end)
    state.total_flashes
  end

  @doc """
    iex> Aoc2021.Day11.p2("inputs/day11.txt")
    337
  """
  def p2(file) do
    grid = parse(file)
    state = OctopiState.new(grid)
    run_till_sync(state, 1)
  end

  def run_till_sync(state, current_day) do
    new_state = update_energy(state)

    if new_state.total_flashes - state.total_flashes == state.width * state.height,
      do: current_day,
      else: run_till_sync(new_state, current_day + 1)
  end

  defp update_energy(state) do
    Enum.reduce(0..(state.height - 1), state, fn y, state ->
      Enum.reduce(0..(state.width - 1), state, fn x, state ->
        OctopiState.update_state(state, {x, y}, false)
      end)
    end)
    |> chain_flashes()
  end

  defp chain_flashes(state) when state.flashing == [], do: state

  defp chain_flashes(state) do
    current_flashes = state.flashing

    state
    |> OctopiState.increment_flashes(length(current_flashes))
    |> OctopiState.clear_flashing()
    |> OctopiState.simulate_flashes(current_flashes)
    |> chain_flashes()
  end

  defp parse(file) do
    parse_input(:lines, file)
    |> Enum.map(fn line ->
      String.split(line, "", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Array.from_list()
      |> Array.fix()
    end)
    |> Array.from_list()
    |> Array.fix()
  end
end

defmodule OctopiState do
  defstruct [:grid, :flashing, :total_flashes, :height, :width]

  alias :array, as: Array

  def new(grid) do
    %OctopiState{
      grid: grid,
      flashing: [],
      total_flashes: 0,
      height: Array.size(grid),
      width: Array.size(Array.get(0, grid))
    }
  end

  def clear_flashing(state), do: %OctopiState{state | flashing: []}
  def add_flashing(state, octopus), do: %OctopiState{state | flashing: [octopus | state.flashing]}

  def increment_flashes(state, value),
    do: %OctopiState{state | total_flashes: state.total_flashes + value}

  def update_grid(state, grid), do: %OctopiState{state | grid: grid}

  def simulate_flashes(state, flashes) do
    Enum.reduce(flashes, state, fn n, state -> update_neighbors(state, n) end)
  end

  defp update_neighbors(state, octopus) do
    Enum.reduce(
      get_neighbors(octopus, state.width, state.height),
      state,
      &update_state(&2, &1, true)
    )
  end

  defp get_neighbors({x, y}, width, height) do
    [
      {x - 1, y - 1},
      {x - 1, y},
      {x - 1, y + 1},
      {x, y - 1},
      {x, y + 1},
      {x + 1, y - 1},
      {x + 1, y},
      {x + 1, y + 1}
    ]
    |> Enum.reject(&out_of_bounds?(&1, width, height))
  end

  def update_state(state, octopus, ignore_zero) do
    energy = get_energy(state.grid, octopus)
    new_grid = update_energy(state.grid, octopus, energy, ignore_zero)
    state = update_grid(state, new_grid)

    if energy == 9 do
      add_flashing(state, octopus)
    else
      state
    end
  end

  defp update_energy(grid, point, 0, true), do: set_energy(grid, point, 0)
  defp update_energy(grid, point, 9, _ignore_zero), do: set_energy(grid, point, 0)
  defp update_energy(grid, point, current, _ignore_zero), do: set_energy(grid, point, current + 1)

  defp get_energy(grid, {x, y}), do: Array.get(x, Array.get(y, grid))

  defp set_energy(grid, {x, y}, value),
    do: Array.set(y, Array.set(x, value, Array.get(y, grid)), grid)

  defp out_of_bounds?({x, y}, m_w, m_h), do: x < 0 or x >= m_w or y < 0 or y >= m_h
end
