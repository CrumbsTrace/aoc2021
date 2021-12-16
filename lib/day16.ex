defmodule Aoc2021.Day16 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day16.p1("inputs/day16.txt")
    960
  """
  def p1(file) do
    {versions, _, _values} = decode_packet([], parse(file), [])
    Enum.sum(versions)
  end

  @doc """
    iex> Aoc2021.Day16.p2("inputs/day16.txt")
    12301926782560
  """
  def p2(file) do
    {_versions, _, values} = decode_packet([], parse(file), [])
    hd(values)
  end

  defp decode_packet(versions, [v1, v2, v3, t1, t2, t3 | bits], values) do
    version = Integer.undigits([v1, v2, v3], 2)
    type = Integer.undigits([t1, t2, t3], 2)
    versions = [version | versions]
    decode_type(type, bits, versions, values, [])
  end

  defp decode_type(4, [b1, b2, b3, b4, b5 | bits], versions, values, intermediate) do
    intermediate = [b5, b4, b3, b2 | intermediate]

    if b1 == 1 do
      decode_type(4, bits, versions, values, intermediate)
    else
      value = Integer.undigits(Enum.reverse(intermediate), 2)
      {versions, bits, [value | values]}
    end
  end

  defp decode_type(instruction, [i1 | bits], versions, values, _) do
    {versions, bits, inner_values} = handle_operation(i1, versions, bits, [])
    {versions, bits, [convert_values(instruction, inner_values) | values]}
  end

  defp handle_operation(0, versions, bits, values) do
    l = Enum.take(bits, 15) |> Integer.undigits(2)
    get_packets(0, versions, Enum.drop(bits, 15), values, l, 0)
  end

  defp handle_operation(1, versions, bits, values) do
    l = Enum.take(bits, 11) |> Integer.undigits(2)
    get_packets(1, versions, Enum.drop(bits, 11), values, l, 0)
  end

  defp get_packets(1, versions, bits, values, expected_length, _) do
    Enum.reduce(1..expected_length, {versions, bits, values}, fn _, {versions, bits, values} ->
      decode_packet(versions, bits, values)
    end)
  end

  defp get_packets(0, versions, bits, values, expected_length, expected_length),
    do: {versions, bits, values}

  defp get_packets(0, versions, bits, values, expected_length, current_length) do
    {versions, new_bits, values} = decode_packet(versions, bits, values)
    bits_used = length(bits) - length(new_bits)
    get_packets(0, versions, new_bits, values, expected_length, current_length + bits_used)
  end

  defp convert_values(0, values), do: Enum.sum(values)
  defp convert_values(1, values), do: Enum.product(values)
  defp convert_values(2, values), do: Enum.min(values)
  defp convert_values(3, values), do: Enum.max(values)
  defp convert_values(5, [v1, v2]), do: if(v2 > v1, do: 1, else: 0)
  defp convert_values(6, [v1, v2]), do: if(v2 < v1, do: 1, else: 0)
  defp convert_values(7, [v1, v2]), do: if(v2 == v1, do: 1, else: 0)

  defp parse(file) do
    parse_input(:lines, file)
    |> hd()
    |> String.to_integer(16)
    |> Integer.digits(2)
    |> pad_bits()
  end

  defp pad_bits(bits) when rem(length(bits), 4) == 0, do: bits
  defp pad_bits(bits), do: pad_bits([0 | bits])

  # def clear_bits(bits) when rem(length(bits), 4) == 0, do: bits
  # def clear_bits([0 | bits]), do: clear_bits(bits)
end
