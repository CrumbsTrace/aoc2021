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
    Enum.reduce(edges, 0, &(&2 + count_routes_edge(caves, caves[&1], block_revisit)))
  end

  def count_routes_edge(caves, edge, block_revisit),
    do: count_routes(caves, edge, block_revisit or is_revisit?(edge))

  defp get_allowed_edges(cave, caves, block_revisit),
    do: Enum.filter(cave.edges, &allowed?(caves[&1], block_revisit))

  defp allowed?(_edge, false), do: true
  defp allowed?(edge, _), do: not edge.small or not edge.visited

  defp is_revisit?(edge), do: edge.small and edge.visited

  defp build_cave_map(file),
    do: Enum.reduce(parse_input(:lines, file), %{}, &update_cave_map/2)

  defp update_cave_map(line, map) do
    [from, to] = String.split(line, "-", trim: true)
    build_connection(map, from, to)
  end

  defp build_connection(caves, from, to) do
    caves = if caves[from] == nil, do: Map.put_new(caves, from, Cave.new(from)), else: caves
    caves = if caves[to] == nil, do: Map.put_new(caves, to, Cave.new(to)), else: caves

    caves
    |> update_edge(from, to)
    |> update_edge(to, from)
  end

  defp update_edge(caves, _from, "start"), do: caves

  defp update_edge(caves, from, to),
    do: Map.update!(caves, from, fn cave -> %{cave | edges: [to | cave.edges]} end)
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
