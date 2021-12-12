defmodule Aoc2021.Day12 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day12.p1("inputs/day12.txt")
    4885
  """
  def p1(file) do
    caves = build_cave_map(file)
    traverse(caves, "start", MapSet.new(), false)
  end

  @doc """
    iex> Aoc2021.Day12.p2("inputs/day12.txt")
    117095
  """
  def p2(file) do
    caves = build_cave_map(file)
    traverse(caves, "start", MapSet.new(), true)
  end

  def traverse(_caves, "end", _visited, _allow_second_visit), do: 1

  def traverse(caves, current, visited, allow_second_visit) do
    visited = MapSet.put(visited, current)
    allowed_neighbors = get_allowed_neighbors(caves, current, visited, allow_second_visit)

    Enum.map(allowed_neighbors, fn neighbor ->
      traverse(
        caves,
        neighbor,
        visited,
        allow_second_visit?(allow_second_visit, visited, neighbor, caves)
      )
    end)
    |> Enum.sum()
  end

  defp get_allowed_neighbors(caves, current, visited, allow_second_visit) do
    Enum.filter(caves[current].neighbors, fn neighbor ->
      allowed?(neighbor, caves, visited, allow_second_visit)
    end)
  end

  defp allowed?(neighbor, _, _, true), do: neighbor != "start"

  defp allowed?(neighbor, caves, visited, _allow_second_visit) do
    not caves[neighbor].small or not MapSet.member?(visited, neighbor)
  end

  defp allow_second_visit?(false, _, _, _), do: false

  defp allow_second_visit?(_allow_second_visit, visited, neighbor, caves),
    do: not caves[neighbor].small or not MapSet.member?(visited, neighbor)

  defp build_cave_map(file) do
    parse_input(:lines, file)
    |> Enum.reduce(%{}, &update_cave_map/2)
  end

  defp update_cave_map(line, map) do
    [from, to] = String.split(line, "-", trim: true)
    build_connecton(map, from, to)
  end

  defp build_connecton(map, from, to) do
    map = if map[from] == nil, do: Map.put_new(map, from, Cave.new(from)), else: map
    map = if map[to] == nil, do: Map.put_new(map, to, Cave.new(to)), else: map

    Map.update!(map, from, fn cave -> %{cave | neighbors: [to | cave.neighbors]} end)
    |> Map.update!(to, fn cave -> %{cave | neighbors: [from | cave.neighbors]} end)
  end
end

defmodule Cave do
  defstruct [:small, :neighbors]

  def new(name) do
    %Cave{
      small: String.downcase(name) == name,
      neighbors: []
    }
  end
end
