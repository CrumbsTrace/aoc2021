defmodule Aoc2021.Day15 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day15.p1("inputs/day15.txt")
    390
  """
  def p1(file), do: run(file, false)

  @doc """
    iex> Aoc2021.Day15.p2("inputs/day15.txt")
    23600
  """
  def p2(file), do: run(file, true)

  defp run(file, times_five) do
    field = parse(file)
    width = tuple_size(elem(field, 1))
    height = tuple_size(field)

    grid = Grid.new(field, width, height)

    find_shortest_path(
      grid,
      {0, 0},
      if(times_five, do: {width * 5 - 1, height * 5 - 1}, else: {width - 1, height - 1}),
      -get_risk(grid, {0, 0}),
      MapSet.new(),
      times_five
    )
    |> get_result(times_five)
  end

  defp get_result(grid, false), do: grid.shortest_paths[{grid.width - 1, grid.height - 1}]
  defp get_result(grid, true), do: grid.shortest_paths[{grid.width * 5 - 1, grid.height * 5 - 1}]

  defp find_shortest_path(grid, target, target, current_risk, _visited, _times_five) do
    risk = get_risk(grid, target)
    Grid.update_shortest_paths(grid, target, risk + current_risk)
  end

  defp find_shortest_path(grid, position, target, current_risk, visited, times_five) do
    existing_value = grid.shortest_paths[position]
    current_risk = current_risk + get_risk(grid, position)

    if existing_value <= current_risk or
         grid.shortest_paths[target] <= current_risk + euclidean_distance(position, target) do
      grid
    else
      grid = Grid.update_shortest_paths(grid, position, current_risk)
      visited = MapSet.put(visited, position)
      neighbors = neighbors(grid, position, target, visited, times_five)

      Enum.reduce(neighbors, grid, fn neighbor, grid ->
        find_shortest_path(grid, neighbor, target, current_risk, visited, times_five)
      end)
    end
  end

  defp neighbors(grid, {p_x, p_y}, target, visited, times_five) do
    [{p_x - 1, p_y}, {p_x + 1, p_y}, {p_x, p_y - 1}, {p_x, p_y + 1}]
    |> Enum.reject(&out_of_bounds?(&1, grid.width, grid.height, times_five))
    |> Enum.reject(&MapSet.member?(visited, &1))
    |> Enum.sort_by(&(euclidean_distance(&1, target) + get_risk(grid, &1)))
  end

  defp euclidean_distance({p_x, p_y}, {t_x, t_y}), do: abs(t_y - p_y) + abs(t_x - p_x)

  defp out_of_bounds?({x, y}, m_w, m_h, times_five) do
    if times_five do
      x < 0 or x >= 5 * m_w or y < 0 or y >= 5 * m_h
    else
      x < 0 or x >= 5 * m_w or y < 0 or y >= 5 * m_h
    end
  end

  defp get_risk(grid, {x, y}) do
    new_x = rem(x, grid.width)
    new_y = rem(y, grid.height)
    offset = div(x, grid.width) + div(y, grid.height)
    rem(elem(elem(grid.field, new_y), new_x) + offset, 10)
  end

  defp parse(file) do
    parse_input(:lines, file)
    |> Enum.map(fn line ->
      String.split(line, "", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> List.to_tuple()
  end
end

defmodule Grid do
  defstruct [:field, :width, :height, :shortest_paths]

  def new(field, width, height) do
    %Grid{
      field: field,
      width: width,
      height: height,
      shortest_paths: %{}
    }
  end

  def update_shortest_paths(grid, position, length),
    do: %Grid{
      grid
      | shortest_paths:
          if(grid.shortest_paths[position] > length,
            do: Map.update(grid.shortest_paths, position, length, &min(&1, length)),
            else: grid.shortest_paths
          )
    }
end
