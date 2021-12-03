defmodule Aoc2021.Day3 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day3.p1("inputs/day3.txt")
    845186

    iex> Aoc2021.Day3.p2("inputs/day3.txt")
    4636702
  """
  def p1(file) do
    parse_input(:lines_characters, file)
    |> Enum.map(&parse_bit_strings/1)
    |> get_gamma_and_epsilon()
  end

  def p2(file) do
    parse_input(:lines_characters, file)
    |> Enum.map(&parse_bit_strings/1)
    |> then(&get_oxygen_and_co2(&1, &1, 0))
  end

  defp get_oxygen_and_co2([oxygen], [co2], _), do: unbits(oxygen) * unbits(co2)

  defp get_oxygen_and_co2(oxygen_list, co2_list, index) do
    filtered_oxygen = filter_bitstrings(oxygen_list, index, false)
    filtered_co2 = filter_bitstrings(co2_list, index, true)
    get_oxygen_and_co2(filtered_oxygen, filtered_co2, index + 1)
  end

  defp filter_bitstrings(list, index, invert) do
    if length(list) == 1 do
      list
    else
      bit = get_bit_row(list, index) |> most_significant_bit()
      bit = if invert, do: 1 - bit, else: bit
      Enum.filter(list, &(Enum.at(&1, index) == bit))
    end
  end

  defp get_bit_row(list, index), do: list |> Enum.zip() |> Enum.at(index)

  defp get_gamma_and_epsilon(bitstrings) do
    significant_bits =
      bitstrings
      |> Enum.zip()
      |> Enum.map(&most_significant_bit/1)

    gamma = unbits(significant_bits)
    epsilon = Enum.map(significant_bits, &(1 - &1)) |> unbits()
    gamma * epsilon
  end

  defp most_significant_bit(bits) do
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
end
