defmodule Aoc2021.Day3 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day3.p1("inputs/day3.txt")
    845186
  """
  # Part 1
  def p1(file) do
    parse_input(:lines_characters, file)
    |> Enum.map(&parse_bit_strings/1)
    |> get_common_bits()
    |> get_gamma_and_epsilon()
  end

  defp get_gamma_and_epsilon(common_bits) do
    gamma = unbits(common_bits)
    epsilon = Integer.pow(2, length(common_bits)) - gamma - 1
    gamma * epsilon
  end

  # Part 2
  @doc """
    iex> Aoc2021.Day3.p2("inputs/day3.txt")
    4636702
  """
  def p2(file) do
    parse_input(:lines_characters, file)
    |> Enum.map(&parse_bit_strings/1)
    |> then(&(p2_filter_input(&1, 0, true) * p2_filter_input(&1, 0, false)))
  end

  defp p2_filter_input([result], _, _), do: unbits(result)

  defp p2_filter_input(list, index, invert) do
    common_bit = get_bit_row(list, index) |> common_bit()
    desired_bit = if invert, do: 1 - common_bit, else: common_bit

    filtered = Enum.filter(list, fn bits -> Enum.at(bits, index) == desired_bit end)
    p2_filter_input(filtered, index + 1, invert)
  end

  # Generic helpers
  defp common_bit(bits) do
    bit_list = Tuple.to_list(bits)
    total_count = Enum.count(bit_list)
    ones = Enum.count(bit_list, &(&1 == 1))

    case ones do
      count when count > total_count / 2 -> 1
      count when count < total_count / 2 -> 0
      _ -> 1
    end
  end

  defp parse_bit_strings(bit_strings), do: Enum.map(bit_strings, &String.to_integer/1)

  defp get_bit_row(list, index), do: list |> Enum.zip() |> Enum.at(index)

  defp get_common_bits(bitstrings), do: bitstrings |> Enum.zip() |> Enum.map(&common_bit/1)
end
