defmodule Aoc2021.Day5 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day5.p1("inputs/day5.txt")
    7142
  """
  def p1(file) do
    table = :ets.new(:lines, [:set])
    handle_input(file) |> Enum.each(fn line -> draw_line(line, table, true) end)

    result =
      :ets.select(table, [{{:_, :"$1"}, [{:>, :"$1", 1}], [:"$1"]}])
      |> Enum.count()

    :ets.delete(table)
    result
  end

  @doc """
    iex> Aoc2021.Day5.p2("inputs/day5.txt")
    20012
  """
  def p2(file) do
    table = :ets.new(:lines, [:set])
    handle_input(file) |> Enum.each(fn line -> draw_line(line, table, false) end)

    result =
      :ets.select(table, [{{:_, :"$1"}, [{:>, :"$1", 1}], [:"$1"]}])
      |> Enum.count()

    :ets.delete(table)
    result
  end

  def draw_line([x1, y1, x2, y2], _, true) when x1 != x2 and y1 != y2, do: :noop

  def draw_line([x1, y1, x2, y2], table, _ignore_diagonal),
    do: get_line_points(x1, y1, x2, y2, table)

  def get_line_points(x1, y1, x1, y1, table),
    do: :ets.update_counter(table, {x1, y1}, 1, {{x1, y1}, 0})

  def get_line_points(x1, y1, x2, y2, table) do
    new_x1 = get_next_coord(x1, x2)
    new_y1 = get_next_coord(y1, y2)
    coord = {x1, y1}

    :ets.update_counter(table, coord, 1, {coord, 0})
    get_line_points(new_x1, new_y1, x2, y2, table)
  end

  def get_next_coord(c1, c1), do: c1
  def get_next_coord(c1, c2), do: c1 + div(c2 - c1, abs(c2 - c1))

  defp handle_input(file) do
    parse_input(:lines, file)
    |> Enum.map(&String.split(&1, [" ", "->", ","], trim: true))
    |> Enum.map(&translate_line/1)
  end

  defp translate_line(line), do: Enum.map(line, &String.to_integer/1)
end
