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
    [8, 1, 4, 7, 6, 5, 2, 3, 9, 0]
    |> Enum.reduce(%{}, &Map.put(&2, &1, Enum.sort(find(&1, signals, &2))))
    |> parse_clock(clock)
  end

  # Easy ones
  defp find(1, line, _s), do: find_helper(line, 2, fn _ -> true end)
  defp find(4, line, _s), do: find_helper(line, 4, fn _ -> true end)
  defp find(7, line, _s), do: find_helper(line, 3, fn _ -> true end)
  defp find(8, line, _s), do: find_helper(line, 7, fn _ -> true end)

  # Comparisons with previously solved digits
  defp find(2, line, s), do: find_helper(line, 5, fn p -> shared_letters(p, s[5]) == 3 end)
  defp find(3, line, s), do: find_helper(line, 5, fn p -> shared_letters(p, s[5]) == 4 end)
  defp find(5, line, s), do: find_helper(line, 5, fn p -> shared_letters(p, s[6]) == 5 end)
  defp find(6, line, s), do: find_helper(line, 6, fn p -> shared_letters(p, s[1]) == 1 end)
  defp find(9, line, s), do: find_helper(line, 6, fn p -> shared_letters(p, s[3]) == 5 end)

  # Last remaining
  defp find(0, line, s), do: find_helper(line, 6, fn p -> Enum.sort(p) not in Map.values(s) end)

  defp find_helper(line, length, query) do
    Enum.find(line, fn pattern -> length(pattern) == length and query.(pattern) end)
  end

  defp parse_clock(solved, clock) do
    Enum.map_join(clock, &match_pattern_with_solution(solved, &1))
    |> String.to_integer()
  end

  defp match_pattern_with_solution(solved, pattern) do
    Enum.find(solved, fn {_, solution} -> solution == Enum.sort(pattern) end) |> elem(0)
  end

  defp shared_letters(p1, p2), do: Enum.count(p1, &(&1 in p2))

  defp parse(file), do: parse_input(:lines, file) |> Enum.map(&parse_line/1)
  defp parse_line(line), do: String.split(line, "|", trim: true) |> Enum.map(&parse_patterns/1)
  defp parse_patterns(patterns), do: String.split(patterns) |> Enum.map(&String.codepoints/1)
end
