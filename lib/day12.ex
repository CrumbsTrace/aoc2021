defmodule Aoc2021.Day12 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day12.p1("inputs/day12.txt")
    4885
  """
  def p1(file) do
    caves = parse_input(:lines, file) |> build_cave_map()
    count_routes(caves, caves["start"], true, 0)
  end

  @doc """
    iex> Aoc2021.Day12.p2("inputs/day12.txt")
    117095
  """
  def p2(file) do
    caves = parse_input(:lines, file) |> build_cave_map()
    count_routes(caves, caves["start"], false, 0)
  end

  def count_routes(_caves, %{name: "end"}, _, total_count), do: total_count + 1

  def count_routes(caves, cave, block_revisit, total_count) do
    caves = Cave.mark_visited(caves, cave)
    edges = get_available_caves(cave.edges, caves, block_revisit)

    Enum.reduce(edges, total_count, fn n, sum ->
      neighbor = caves[n]
      count_routes(caves, neighbor, block_revisit or is_revisit?(neighbor), sum)
    end)
  end

  defp get_available_caves(edges, _, false), do: edges
  defp get_available_caves(edges, caves, _), do: Enum.filter(edges, &(!is_revisit?(caves[&1])))

  defp is_revisit?(edge), do: edge.small and edge.visited

  defp build_cave_map(lines), do: Enum.reduce(lines, %{}, &update_cave_map/2)

  defp update_cave_map(connection, caves) do
    [from, to] = String.split(connection, "-", trim: true)
    create_connection(caves, from, to)
  end

  defp create_connection(caves, from, to) do
    caves
    |> Cave.maybe_add_cave(from)
    |> Cave.maybe_add_cave(to)
    |> Cave.add_edge(from, to)
    |> Cave.add_edge(to, from)
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

  def maybe_add_cave(caves, from),
    do: if(caves[from] == nil, do: Map.put_new(caves, from, Cave.new(from)), else: caves)

  def mark_visited(caves, cave), do: Map.replace!(caves, cave.name, %{cave | visited: true})

  def add_edge(caves, _from, "start"), do: caves

  def add_edge(caves, from, to),
    do: Map.update!(caves, from, fn cave -> %{cave | edges: [to | cave.edges]} end)
end
