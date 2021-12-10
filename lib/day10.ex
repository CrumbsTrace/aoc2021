defmodule Aoc2021.Day10 do
  import Aoc2021.Helpers

  @open_brackets ["(", "[", "{", "<"]

  @doc """
    iex> Aoc2021.Day10.p1("inputs/day10.txt")
    319329
  """
  def p1(file) do
    parse(file)
    |> Enum.map(fn line -> find_illegal_character(line) end)
    |> Enum.map(&score(&1, false))
    |> Enum.sum()
  end

  @doc """
    iex> Aoc2021.Day10.p2("inputs/day10.txt")
    3515583998
  """
  def p2(file) do
    scores =
      parse(file)
      |> Enum.map(fn line -> find_illegal_character(line) end)
      |> Enum.filter(fn illegal -> is_list(illegal) end)
      |> Enum.map(&p2_score/1)
      |> Enum.sort()

    Enum.at(scores, div(length(scores), 2))
  end

  defp p2_score(closings), do: Enum.reduce(closings, 0, fn c, acc -> acc * 5 + score(c, true) end)

  defp find_illegal_character(line) do
    Enum.reduce_while(line, [], fn c, closing_stack ->
      if c in @open_brackets,
        do: {:cont, [closing(c) | closing_stack]},
        else: verify_closing(c, closing_stack)
    end)
  end

  def score(")", autocomplete), do: if(autocomplete, do: 1, else: 3)
  def score("]", autocomplete), do: if(autocomplete, do: 2, else: 57)
  def score("}", autocomplete), do: if(autocomplete, do: 3, else: 1197)
  def score(">", autocomplete), do: if(autocomplete, do: 4, else: 25137)
  def score(_, _), do: 0

  defp verify_closing(c, [expected | tail]) do
    if c == expected, do: {:cont, tail}, else: {:halt, c}
  end

  defp closing("("), do: ")"
  defp closing("{"), do: "}"
  defp closing("<"), do: ">"
  defp closing("["), do: "]"

  defp parse(file) do
    parse_input(:lines, file)
    |> Enum.map(&String.split(&1, "", trim: true))
  end
end
