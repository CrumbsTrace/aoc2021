defmodule Aoc2021.Day19 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day19.p1("inputs/day19.txt")
    308
  """
  def p1(file) do
    scanners = parse(file)

    solve_offsets(scanners)
    |> Map.values()
    |> Enum.map(& &1.beacons)
    |> Enum.reduce(MapSet.new(), &MapSet.union(&2, &1))
    |> MapSet.size()
  end

  @doc """
    iex> Aoc2021.Day19.p2("inputs/day19.txt")
    12124
  """
  def p2(file) do
    scanners = parse(file)

    solve_offsets(scanners)
    |> Map.values()
    |> Enum.map(& &1.position)
    |> all_combinations()
    |> Enum.map(fn {p1, p2} -> manhattan(p1, p2) end)
    |> Enum.max()
  end

  defp solve_offsets(scanners, already_tried \\ []) do
    scanners_to_try =
      Map.values(scanners) |> Enum.filter(&(&1.beacons != nil and &1.index not in already_tried))

    scanners = Enum.reduce(scanners_to_try, scanners, &position_scanners/2)

    solved_scanner_count = Map.values(scanners) |> Enum.count(&(&1.beacons != nil))

    if solved_scanner_count == map_size(scanners) do
      scanners
    else
      used_scanners = Enum.map(scanners_to_try, & &1.index)
      solve_offsets(scanners, used_scanners ++ already_tried)
    end
  end

  defp position_scanners(solved_scanner, scanners) do
    unsolved_scanners = Enum.filter(scanners, &(elem(&1, 1).beacons == nil))
    Enum.reduce(unsolved_scanners, scanners, &position_if_match(solved_scanner, &1, &2))
  end

  defp position_if_match(solved_scanner, {key, scanner}, scanners) do
    result =
      Enum.map(
        scanner.beacon_options,
        &overlaps?(MapSet.to_list(solved_scanner.beacons), solved_scanner.beacons, &1)
      )
      |> Enum.find(fn {overlaps, _} -> overlaps end)

    if result != nil do
      {_, {offset, beacons}} = result
      Map.replace!(scanners, key, Scanner.update_scanner(scanner, beacons, offset))
    else
      scanners
    end
  end

  defp overlaps?([], _beacons1, _beacons2), do: {false, nil}

  defp overlaps?([beacon | tail], beacons1, beacons2) do
    possible_offsets =
      Enum.map(
        beacons2,
        &offset(&1, beacon)
      )

    positioned =
      Enum.map(possible_offsets, fn offset ->
        {offset, MapSet.new(beacons2, &offset(&1, offset))}
      end)
      |> Enum.find(fn {_offset, mapset} ->
        MapSet.size(MapSet.intersection(beacons1, mapset)) >= 12
      end)

    if positioned != nil do
      {true, positioned}
    else
      overlaps?(tail, beacons1, beacons2)
    end
  end

  defp manhattan({x1, y1, z1}, {x2, y2, z2}), do: abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2)

  defp offset({x1, y1, z1}, {x2, y2, z2}), do: {x1 - x2, y1 - y2, z1 - z2}

  defp parse(file) do
    lines = parse_input(:lines, file)
    scanners = parse_scanners(lines) |> Enum.with_index()

    Map.new(scanners, fn {beacons, index} -> {index, Scanner.new(beacons, index)} end)
    |> Map.update!(
      0,
      &Scanner.update_scanner(&1, MapSet.new(Enum.at(&1.beacon_options, 0)), {0, 0, 0})
    )
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
        String.split(line, ",", trim: true) |> Enum.map(&String.to_integer/1)
      end)

    [MapSet.new(beacons) | parse_scanners(Enum.drop(lines, length(beacons)))]
  end
end

defmodule Scanner do
  defstruct [:beacons, :beacon_options, :position, :index]

  def new(beacons, index) do
    %Scanner{
      beacon_options: generate_beacon_options(beacons),
      index: index
    }
  end

  def update_scanner(scanner, beacons, position) do
    %Scanner{scanner | beacons: beacons, position: position}
  end

  defp generate_beacon_options(beacons) do
    Enum.map(beacons, fn [x, y, z] ->
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
