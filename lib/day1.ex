defmodule Aoc2021.Day1 do
  @doc """
    iex> Aoc2021.Day1.p1()
    1154
  """
  def p1(), do: parse_input() |> count_increases(1)

  @doc """
    iex> Aoc2021.Day1.p2()
    1127
  """
  def p2(), do: parse_input() |> count_increases(3)

  defp count_increases(list, offset) do
    list
    |> Enum.drop(offset)
    |> Enum.zip(list)
    |> Enum.count(fn {x, y} -> y > x end)
  end

  defp parse_input() do
    File.read!("inputs/day1.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
