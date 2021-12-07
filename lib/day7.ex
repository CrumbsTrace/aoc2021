defmodule Aoc2021.Day7 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day7.p1("inputs/day7.txt")
    336701
  """
  def p1(file) do
    sorted_crabs = parse(file) |> Enum.sort()

    Enum.at(sorted_crabs, div(Enum.count(sorted_crabs), 2) - 1)
    |> calculate_fuel_constant(sorted_crabs)
  end

  @doc """
    iex> Aoc2021.Day7.p2("inputs/day7.txt")
    95167302
  """
  def p2(file) do
    crabs = parse(file)
    {min, max} = Enum.min_max(crabs)

    for p <- min..max do
      calculate_fuel_linear(crabs, p)
    end
    |> Enum.min()
  end

  defp calculate_fuel_constant(pos, crabs), do: Enum.map(crabs, &abs(&1 - pos)) |> Enum.sum()

  defp calculate_fuel_linear(crabs, pos) do
    Enum.map(crabs, &sum_of_integers(abs(&1 - pos))) |> Enum.sum()
  end

  defp sum_of_integers(number), do: trunc(number * (number + 1) / 2)

  def parse(file) do
    parse_input(:lines, file)
    |> hd()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
