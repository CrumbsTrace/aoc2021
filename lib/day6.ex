defmodule Aoc2021.Day6 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day6.p1("inputs/day6.txt")
    386536
  """
  def p1(file), do: run(file, 80)

  @doc """
    iex> Aoc2021.Day6.p2("inputs/day6.txt")
    1732821262171
  """
  def p2(file), do: run(file, 256)

  defp run(file, days) do
    fish_map = build_fish_map(file)

    Enum.reduce(0..(days - 1), fish_map, fn _, fish_map -> update_fish_map(fish_map) end)
    |> Map.values()
    |> Enum.sum()
  end

  defp update_fish_map(fish_map) do
    new_fish = Map.get(fish_map, 0, 0)

    Enum.reduce(0..7, fish_map, &shift_fish_map_at_index/2)
    |> Map.replace!(8, new_fish)
    |> Map.update!(6, &(&1 + new_fish))
  end

  defp shift_fish_map_at_index(index, fish_map) do
    new_value = Map.get(fish_map, index + 1, 0)
    Map.update!(fish_map, index, fn _ -> new_value end)
  end

  defp build_fish_map(file) do
    parse_input(:lines, file)
    |> hd()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(preload_map(), fn fish_time, acc -> Map.update!(acc, fish_time, &(&1 + 1)) end)
  end

  defp preload_map, do: for(x <- 0..8, do: {x, 0}) |> Map.new()
end
