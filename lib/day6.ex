defmodule Aoc2021.Day6 do
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

    1..days
    |> Enum.reduce(fish, fn _, fishes -> update_fish(fishes) end)
    |> Tuple.sum()
  end

  defp update_fish({f0, f1, f2, f3, f4, f5, f6, f7, f8}) do
    {f1, f2, f3, f4, f5, f6, f7 + f0, f8, f0}
  end

  defp build_fish(file) do
    frequencies =
      File.read!(file)
      |> String.split([",", "\n"], trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.frequencies()

    for(i <- 0..8, do: frequencies[i] || 0) |> List.to_tuple()
  end
end
