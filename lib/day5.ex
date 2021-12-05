defmodule Aoc2021.Day5 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day5.p1("inputs/day5.txt")
    7142

    iex> Aoc2021.Day5.p2("inputs/day5.txt")
    20012
  """
  @count_check [{{:_, :"$1"}, [{:>, :"$1", 1}], [true]}]

  def p1(file), do: run(file, true)
  def p2(file), do: run(file, false)

  def run(file, ignore_diagonal) do
    table = :ets.new(:pipes, [:set])
    handle_input(file) |> Enum.each(fn line -> draw_pipes(line, table, ignore_diagonal) end)
    result = :ets.select_count(table, @count_check)
    :ets.delete(table)
    result
  end

  def draw_pipes([x1, y1, x2, y2], _, true) when x1 != x2 and y1 != y2, do: :noop
  def draw_pipes([x1, y1, x2, y2], table, _ignore_diag), do: update_pipes(x1, y1, x2, y2, table)

  def update_pipes(x1, y1, x2, y2, table) do
    update_count(table, cantor_pairing(x1, y1))

    if x1 != x2 or y1 != y2 do
      update_pipes(x1 + sign(x1, x2), y1 + sign(y1, y2), x2, y2, table)
    end
  end

  def cantor_pairing(x, y), do: div((x + y) * (x + y + 1), 2) + y

  defp handle_input(file) do
    parse_input(:lines, file)
    |> Enum.map(&String.split(&1, ["->", " ", ","], trim: true))
    |> Enum.map(&translate_line/1)
  end

  defp update_count(table, coord), do: :ets.update_counter(table, coord, 1, {nil, 0})

  defp translate_line(line), do: Enum.map(line, &String.to_integer/1)
end
