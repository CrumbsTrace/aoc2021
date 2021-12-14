defmodule Aoc2021.Day14 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day14.p1("inputs/day14.txt")
    2360
  """
  def p1(file), do: run(file, 10)

  @doc """
    iex> Aoc2021.Day14.p2("inputs/day14.txt")
    2967977072188
  """
  def p2(file), do: run(file, 40)

  defp run(file, steps) do
    {pairs, instructions, first_character, last_character} = parse(file)

    polymer_pairs =
      Enum.reduce(0..(steps - 1), pairs, fn _, pairs -> polymerize(pairs, instructions) end)

    counts = count_elements(polymer_pairs, first_character, last_character)

    {min, max} = Map.values(counts) |> Enum.min_max()
    div(max, 2) - div(min, 2)
  end

  defp polymerize(pairs, instructions) do
    Enum.reduce(pairs, %{}, fn {pair, frequency}, pairs ->
      {new_pair1, new_pair2} = instructions[pair]

      pairs
      |> Map.update(new_pair1, frequency, &(&1 + frequency))
      |> Map.update(new_pair2, frequency, &(&1 + frequency))
    end)
  end

  defp count_elements(polymer_pairs, first_character, last_character) do
    Enum.reduce(polymer_pairs, %{}, fn {pair, frequency}, counts ->
      [e1, e2] = String.split(pair, "", trim: true)

      counts
      |> Map.update(e1, frequency, &(&1 + frequency))
      |> Map.update(e2, frequency, &(&1 + frequency))
    end)
    |> Map.update!(first_character, &(&1 + 1))
    |> Map.update!(last_character, &(&1 + 1))
  end

  defp parse(file) do
    lines = parse_input(:lines, file)
    start = Enum.at(lines, 0) |> String.split("", trim: true)
    first_character = Enum.at(start, 0)
    last_character = Enum.at(start, -1)
    starting_pairs = create_starting_pairs(start) |> Enum.frequencies()

    instructions =
      Enum.drop(lines, 1)
      |> Enum.map(&setup_conversion/1)
      |> Map.new()

    {starting_pairs, instructions, first_character, last_character}
  end

  defp create_starting_pairs([x, y]), do: [x <> y]

  defp create_starting_pairs([x, y | rest]) do
    [x <> y | create_starting_pairs([y | rest])]
  end

  defp setup_conversion(instruction) do
    [pair, insert] = String.split(instruction, " -> ", trim: true)
    {pair, {String.at(pair, 0) <> insert, insert <> String.at(pair, 1)}}
  end
end
