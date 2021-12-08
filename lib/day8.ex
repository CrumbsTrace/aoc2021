defmodule Aoc2021.Day8 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day8.p1("inputs/day8.txt")
    539
  """
  def p1(file) do
    parse(file)
    |> Enum.flat_map(&Enum.at(&1, 1))
    |> Enum.frequencies_by(&length/1)
    |> Enum.filter(fn {length, _frequency} -> length in [2, 3, 4, 7] end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  @doc """
    iex> Aoc2021.Day8.p2("inputs/day8.txt")
    1084606
  """
  def p2(file) do
    parse(file)
    |> Enum.map(&solve/1)
    |> Enum.sum()
  end

  defp solve([signals, clock]) do
    solved =
      [8, 1, 4, 7, 6, 5, 2, 3, 9, 0]
      |> Enum.reduce(%{}, fn digit, solved -> determine_digit(digit, signals, solved) end)

    clock
    |> Enum.map(&find_digit(solved, &1))
    |> Enum.join()
    |> String.to_integer()
  end

  defp find_digit(solved, pattern) do
    Enum.find(solved, fn {_, p} -> p == Enum.sort(pattern) end)
    |> elem(0)
  end

  defp determine_digit(digit, line, solved) do
    Map.put(solved, digit, Enum.sort(determine(digit, line, solved)))
  end

  defp determine(0, line, s), do: Enum.find(line, &(Enum.sort(&1) not in Map.values(s)))
  defp determine(1, line, _s), do: Enum.find(line, &(length(&1) == 2))
  defp determine(2, line, s), do: Enum.find(line, fn p -> l(p, 5) and sharing(p, s[5]) == 3 end)
  defp determine(3, line, s), do: Enum.find(line, fn p -> l(p, 5) and sharing(p, s[5]) == 4 end)
  defp determine(4, line, _s), do: Enum.find(line, &(length(&1) == 4))
  defp determine(5, line, s), do: Enum.find(line, fn p -> l(p, 5) and sharing(p, s[6]) == 5 end)
  defp determine(6, line, s), do: Enum.find(line, fn p -> l(p, 6) and sharing(s[1], p) == 1 end)
  defp determine(7, line, _s), do: Enum.find(line, &(length(&1) == 3))
  defp determine(8, _line, _s), do: ["a", "b", "c", "d", "e", "f", "g"]
  defp determine(9, line, s), do: Enum.find(line, fn p -> l(p, 6) and sharing(s[3], p) == 5 end)

  defp l(p, n), do: length(p) == n

  defp sharing(p1, p2), do: Enum.count(p1, &(&1 in p2))

  defp parse(file) do
    parse_input(:lines, file)
    |> Enum.map(fn line ->
      String.split(line, "|", trim: true)
      |> Enum.map(
        &(String.split(&1, " ", trim: true)
          |> Enum.map(fn number -> String.split(number, "", trim: true) end))
      )
    end)
  end
end
