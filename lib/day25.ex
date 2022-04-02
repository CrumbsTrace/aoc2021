defmodule Aoc2021.Day25 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day25.p1("inputs/day25.txt")
    386
  """
  def p1(file) do
    input = parse(file)
    {{x, _}, _} = Enum.max_by(input, fn {{x, _}, _} -> x end)
    {{_, y}, _} = Enum.max_by(input, fn {{_, y}, _} -> y end)
    move_till_standstill(input, x, y, 1)
  end

  def move_till_standstill(cucumbers, width, height, step) do
    new_cucumbers =
      move_east(cucumbers, width, height)
      |> move_south(width, height)

    if new_cucumbers == cucumbers,
      do: step,
      else: move_till_standstill(new_cucumbers, width, height, step + 1)
  end

  def move_east(old_cucumbers, width, _) do
    Enum.reduce(old_cucumbers, Map.new(), fn {{x, y}, v}, cucumbers ->
      if v == ">" and not Map.has_key?(old_cucumbers, {rem(x + 1, width + 1), y}),
        do: Map.put(cucumbers, {rem(x + 1, width + 1), y}, v),
        else: Map.put(cucumbers, {x, y}, v)
    end)
  end

  def move_south(old_cucumbers, _, height) do
    Enum.reduce(old_cucumbers, Map.new(), fn {{x, y}, v}, cucumbers ->
      if v == "v" and not Map.has_key?(old_cucumbers, {x, rem(y + 1, height + 1)}),
        do: Map.put(cucumbers, {x, rem(y + 1, height + 1)}, v),
        else: Map.put(cucumbers, {x, y}, v)
    end)
  end

  defp parse(file) do
    parse_input(:lines, file)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), fn {line, y}, cucumbers ->
      Enum.with_index(line)
      |> Enum.reduce(cucumbers, fn {c, x}, cucumbers ->
        if c != ".", do: Map.put(cucumbers, {x, y}, c), else: cucumbers
      end)
    end)
  end
end
