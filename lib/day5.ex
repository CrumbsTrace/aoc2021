defmodule Aoc2021.Day5 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day5.p1("inputs/day5.txt")
    7142

    iex> Aoc2021.Day5.p2("inputs/day5.txt")
    20012
  """
  @count_check [{{:_, :"$1"}, [{:>, :"$1", 1}], [:"$1"]}]

  def p1(file), do: run(file, true)
  def p2(file), do: run(file, false)

  def run(file, ignore_diagonal) do
    table = :ets.new(:pipes, [:set])
    handle_input(file) |> Enum.each(fn line -> draw_line(line, table, ignore_diagonal) end)
    result = :ets.select(table, @count_check) |> Enum.count()
    :ets.delete(table)
    result
  end

  def draw_line([x1, y1, x2, y2], _, true) when x1 != x2 and y1 != y2, do: :noop
  def draw_line([x1, y1, x2, y2], table, _ignore_diagonal), do: get_points(x1, y1, x2, y2, table)

  def get_points(x1, y1, x2, y2, table) do
    update_count(table, {x1, y1})

    if x1 == x2 and y1 == y2 do
      :noop
    else
      new_x1 = x1 + sign(x1, x2)
      new_y1 = y1 + sign(y1, y2)
      get_points(new_x1, new_y1, x2, y2, table)
    end
  end

  def sign(c1, c1), do: 0
  def sign(c1, c2), do: if(c2 > c1, do: 1, else: -1)

  defp handle_input(file) do
    parse_input(:lines, file)
    |> Enum.map(&String.split(&1, [" ", "->", ","], trim: true))
    |> Enum.map(&translate_line/1)
  end

  defp update_count(table, coord), do: :ets.update_counter(table, coord, 1, {coord, 0})

  defp translate_line(line), do: Enum.map(line, &String.to_integer/1)
end
