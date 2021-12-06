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
    fish = build_fish(file)

    Enum.reduce(0..(days - 1), fish, fn _, fish -> update_fish(fish) end)
    |> Map.values()
    |> Enum.sum()
  end

  defp update_fish(fish) do
    new_fish = Map.get(fish, 0, 0)

    Enum.reduce(0..7, fish, &Map.replace!(&2, &1, Map.get(&2, &1 + 1)))
    |> Map.replace!(8, new_fish)
    |> Map.update!(6, &(&1 + new_fish))
  end

  defp build_fish(file) do
    parse_input(:lines, file)
    |> hd()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(preload_fish(), fn fish_time, acc -> Map.update!(acc, fish_time, &(&1 + 1)) end)
  end

  defp preload_fish, do: for(x <- 0..8, do: {x, 0}) |> Map.new()
end
