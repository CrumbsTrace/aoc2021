defmodule Aoc2021.Day9 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day9.p1("inputs/day9.txt")
    585
  """
  def p1(file) do
    grid = parse(file)
    max_width = tuple_size(elem(grid, 0))
    max_height = tuple_size(grid)

    get_lowest_points(grid, max_width, max_height)
    |> Enum.map(&(get_depth(grid, &1) + 1))
    |> Enum.sum()
  end

  @doc """
    iex> Aoc2021.Day9.p2("inputs/day9.txt")
    827904
  """
  def p2(file) do
    grid = parse(file)
    max_width = tuple_size(elem(grid, 0))
    max_height = tuple_size(grid)

    get_lowest_points(grid, max_width, max_height)
    |> Enum.map(&MapSet.size(get_basin(grid, &1, max_width, max_height)))
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  defp get_lowest_points(grid, max_width, max_height) do
    0..(max_height - 1)
    |> Enum.reduce(
      [],
      fn y, acc ->
        Enum.reduce(0..(max_width - 1), acc, fn x, cell_acc ->
          if lowest?(grid, x, y, max_width, max_height),
            do: [{x, y} | cell_acc],
            else: cell_acc
        end)
      end
    )
  end

  def get_basin(grid, point, m_w, m_h, seen \\ MapSet.new()) do
    new_neighbors =
      get_neighbors(point, m_w, m_h)
      |> Enum.filter(&(get_depth(grid, &1) != 9 and not MapSet.member?(seen, &1)))

    seen = Enum.reduce(new_neighbors, seen, &MapSet.put(&2, &1))
    Enum.reduce(new_neighbors, seen, &MapSet.union(&2, get_basin(grid, &1, m_w, m_h, &2)))
  end

  def get_neighbors({x, y}, max_width, max_height) do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    |> Enum.reject(&out_of_bounds?(&1, max_width, max_height))
  end

  defp out_of_bounds?({x, y}, m_w, m_h), do: x < 0 or x >= m_w or y < 0 or y >= m_h

  defp lowest?(grid, x, y, m_w, m_h) do
    depth = get_depth(grid, {x, y})

    Enum.all?(get_neighbors({x, y}, m_w, m_h), fn neighbor ->
      get_depth(grid, neighbor) > depth
    end)
  end

  defp get_depth(grid, {x, y}), do: elem(elem(grid, y), x)

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
