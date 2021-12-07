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
    handle_input(file) |> Enum.each(fn line -> update_pipes(line, table, ignore_diagonal) end)
    result = :ets.select_count(table, @count_check)
    :ets.delete(table)
    result
  end

  def update_pipes([x1, y1, x2, y2], ets, ignore), do: update_pipes(x1, y1, x2, y2, ets, ignore)
  def update_pipes(x1, y1, x2, y2, _, true) when x1 != x2 and y1 != y2, do: :noop
  def update_pipes(x, y, x, y, ets, _), do: update_count(ets, cantor_pairing(x, y))

  def update_pipes(x1, y1, x2, y2, ets, ignore_diagonal) do
    update_count(ets, cantor_pairing(x1, y1))
    update_pipes(x1 + sign(x1, x2), y1 + sign(y1, y2), x2, y2, ets, ignore_diagonal)
  end

  def cantor_pairing(x, y), do: div((x + y) * (x + y + 1), 2) + y

  defp handle_input(file) do
    parse_input(:lines, file)
    |> Enum.map(&String.split(&1, ["->", " ", ","], trim: true))
    |> Enum.map(fn
      pipes -> Enum.map(pipes, &String.to_integer/1)
    end)
  end

  defp update_count(table, coord), do: :ets.update_counter(table, coord, 1, {nil, 0})
end
