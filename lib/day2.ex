defmodule Aoc2021.Day2 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day2.p1("inputs/day2.txt")
    1488669

    iex> Aoc2021.Day2.p2("inputs/day2.txt")
    1176514794
  """
  def p1(file) do
    process_input(file)
    |> Enum.reduce({0, 0}, &update_state/2)
    |> Tuple.product()
  end

  def p2(file) do
    process_input(file)
    |> Enum.reduce({0, 0, 0}, &update_state/2)
    |> then(fn {x, y, _} -> x * y end)
  end

  defp process_input(file), do: parse_input(:lines_spaces, file) |> Enum.map(&translate/1)

  defp update_state({dx, dy}, {x, y, aim}), do: {x + dx, y + dx * aim, aim + dy}
  defp update_state({dx, dy}, {x, y}), do: {x + dx, y + dy}

  defp translate(["forward", dx]), do: {String.to_integer(dx), 0}
  defp translate(["down", dx]), do: {0, String.to_integer(dx)}
  defp translate(["up", dx]), do: {0, -String.to_integer(dx)}
end
