defmodule Aoc2021.Day19 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day19.p1("inputs/day19.txt")
    308
  """
  def p1(file) do
    {solved, remaining} = parse(file)

    solve_offsets(solved, [], remaining)
    |> Enum.map(&elem(&1, 1))
    |> Enum.reduce(MapSet.new(), &MapSet.union(&2, MapSet.new(&1)))
    |> MapSet.size()
  end

  @doc """
    iex> Aoc2021.Day19.p2("inputs/day19.txt")
    12124
  """
  def p2(file) do
    {solved, remaining} = parse(file)

    solve_offsets(solved, [], remaining)
    |> Enum.map(&elem(&1, 0))
    |> all_combinations()
    |> Enum.map(fn {p1, p2} -> manhattan(p1, p2) end)
    |> Enum.max()
  end

  defp solve_offsets(to_try, solved, []), do: to_try ++ solved

  defp solve_offsets([hd | to_try], solved, to_solve) do
    {new_solved, to_solve} = solve_scanner(hd, to_solve)
    solve_offsets(new_solved ++ to_try, [hd | solved], to_solve)
  end

  defp solve_scanner({_, beacons}, to_solve) do
    Enum.reduce(to_solve, {[], to_solve}, fn scanner, {solved, to_solve} = c ->
      solution = solve(beacons, scanner)

      if solution != nil,
        do: {[solution | solved], Enum.filter(to_solve, &(&1 != scanner))},
        else: c
    end)
  end

  defp solve(absolute_beacons, scanner) do
    Enum.find_value(scanner.beacon_options, fn option ->
      offset = find_offset(option, absolute_beacons)

      if offset != nil do
        beacons = Enum.map(option, &offset(&1, offset))
        {offset, beacons}
      end
    end)
  end

  defp find_offset(beacons_left, _solved_beacons) when length(beacons_left) < 12, do: nil

  defp find_offset([beacon | tail] = beacons, solved_beacons) do
    Enum.find_value(solved_beacons, find_offset(tail, solved_beacons), fn solved_beacon ->
      offset = offset(beacon, solved_beacon)
      overlap_count = Enum.count(beacons, &Enum.member?(solved_beacons, offset(&1, offset)))
      if overlap_count >= 12, do: offset
    end)
  end

  defp manhattan({x1, y1, z1}, {x2, y2, z2}), do: abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2)

  defp offset({x1, y1, z1}, {x2, y2, z2}), do: {x1 - x2, y1 - y2, z1 - z2}

  defp parse(file) do
    lines = parse_input(:lines, file)
    [head | rest] = parse_scanners(lines)
    {[{{0, 0, 0}, head}], Enum.map(rest, fn beacons -> Scanner.new(beacons) end)}
  end

  defp all_combinations([_]), do: []

  defp all_combinations([x | tail]) do
    combinations =
      for y <- tail do
        {x, y}
      end

    combinations ++ all_combinations(tail)
  end

  defp parse_scanners([]), do: []

  defp parse_scanners(lines) do
    lines = Enum.drop(lines, 1)

    beacons =
      Enum.take_while(lines, &(not String.contains?(&1, "scanner")))
      |> Enum.map(fn line ->
        String.split(line, ",", trim: true) |> Enum.map(&String.to_integer/1) |> List.to_tuple()
      end)

    [beacons | parse_scanners(Enum.drop(lines, length(beacons)))]
  end
end

defmodule Scanner do
  defstruct [:beacon_options]

  def new(beacons) do
    %Scanner{
      beacon_options: generate_beacon_options(beacons)
    }
  end

  defp generate_beacon_options(beacons) do
    Enum.map(beacons, fn {x, y, z} ->
      [
        {x, y, z},
        {x, -z, y},
        {x, -y, -z},
        {x, z, -y},
        {-x, -y, z},
        {-x, -z, -y},
        {-x, y, -z},
        {-x, z, y},
        {y, -z, -x},
        {y, z, x},
        {y, -x, z},
        {y, x, -z},
        {-y, x, z},
        {-y, -x, -z},
        {-y, -z, x},
        {-y, z, -x},
        {z, x, y},
        {z, -x, -y},
        {z, -y, x},
        {z, y, -x},
        {-z, x, -y},
        {-z, -x, y},
        {-z, y, x},
        {-z, -y, -x}
      ]
    end)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list(&1))
  end
end
