defmodule Aoc2021.Day12 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day12.p1("inputs/day12.txt")
    4885
  """
  def p1(file) do
    caves = build_cave_map(file)
    count_routes(caves, caves["start"], true)
  end

  @doc """
    iex> Aoc2021.Day12.p2("inputs/day12.txt")
    117095
  """
  def p2(file) do
    caves = build_cave_map(file)
    count_routes(caves, caves["start"], false)
  end

  def count_routes(_caves, %{name: "end"}, _block_revisit), do: 1

  def count_routes(caves, cave, block_revisit) do
    caves = Cave.mark_visited(caves, cave)
    edges = get_allowed_edges(cave, caves, block_revisit)

    Enum.map(edges, &count_routes_edge(caves, caves[&1], block_revisit))
    |> Enum.sum()
  end

  def count_routes_edge(caves, edge, block_revisit),
    do: count_routes(caves, edge, block_revisit or revisit?(edge))

  defp get_allowed_edges(cave, caves, block_revisit),
    do: Enum.filter(cave.edges, &allowed?(caves[&1], block_revisit))

  defp allowed?(edge, allow_second_visit) do
    if not allow_second_visit,
      do: edge.name != "start",
      else: not edge.small or not edge.visited
  end

  defp revisit?(edge), do: edge.small and edge.visited

  defp build_cave_map(file),
    do: Enum.reduce(parse_input(:lines, file), %{}, &update_cave_map/2)

  defp update_cave_map(line, map) do
    [from, to] = String.split(line, "-", trim: true)
    build_connecton(map, from, to)
  end

  defp build_connecton(map, from, to) do
    map = if map[from] == nil, do: Map.put_new(map, from, Cave.new(from)), else: map
    map = if map[to] == nil, do: Map.put_new(map, to, Cave.new(to)), else: map

    Map.update!(map, from, fn cave -> %{cave | edges: [to | cave.edges]} end)
    |> Map.update!(to, fn cave -> %{cave | edges: [from | cave.edges]} end)
  end
end

defmodule Cave do
  defstruct [:small, :edges, :name, visited: false]

  def new(name) do
    %Cave{
      name: name,
      small: String.downcase(name) == name,
      edges: [],
      visited: false
    }
  end

  def mark_visited(caves, cave), do: Map.replace!(caves, cave.name, %{cave | visited: true})
end
