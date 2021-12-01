defmodule Aoc2021.Day1 do
  @doc """
    TEST:
    iex> Aoc2021.Day1.p1()
    1154
  """
  def p1() do
    parse_input() |> count_increased()
  end

  @doc """
    Create the same list with an offset so with list [A, B, C, D] also create [B, C, D, A] and [C, D, A, B]
    Zip the 3 together and take the sums. Then just do what p1 did

    TEST:
    iex> Aoc2021.Day1.p2()
    1127
  """
  def p2() do
    # Regular [A, B, C, D]
    list = parse_input()

    # An infinitely repeating version of the list so we can easily take the offset lists with the loop
    cycled_input = Stream.cycle(list)

    # Offset 1 [B, C, D, A]
    list_offset1 = Enum.slice(cycled_input, 1, Enum.count(list))
    # Offset 2 [C, D, A, B]
    list_offset2 = Enum.slice(cycled_input, 2, Enum.count(list))

    # Zip to [ABC, BCD, CDA, DAB], take sums and then count the increases
    Enum.zip([list, list_offset1, list_offset2])
    |> Enum.map(fn {x, y, z} -> x + y + z end)
    |> then(&count_increased/1)
  end

  defp count_increased(list1) do
    list2 = Enum.slice(list1, 1, Enum.count(list1))

    Enum.zip(list1, list2)
    |> Enum.count(fn {x, y} -> y - x > 0 end)
  end

  defp parse_input() do
    File.read!("inputs/day1.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
