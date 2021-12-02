defmodule Aoc2021.Day1 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day1.p1("inputs/day1.txt")
    1154

    iex> Aoc2021.Day1.p2("inputs/day1.txt")
    1127
  """
  def p1(file), do: parse_number_input(file) |> count_increases(1)
  def p2(file), do: parse_number_input(file) |> count_increases(3)

  defp count_increases(list, offset) do
    list
    |> Enum.drop(offset)
    |> Enum.zip_reduce(list, 0, &increment_if_increase/3)
  end

  defp increment_if_increase(x, y, acc) when x > y, do: acc + 1
  defp increment_if_increase(_, _, acc), do: acc
end
