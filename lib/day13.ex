defmodule Aoc2021.Day13 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day13.p1("inputs/day13.txt")
    661
  """
  def p1(file) do
    {points, folds} = parse(file)

    result =
      fold(points, hd(folds))
      |> Enum.uniq()
      |> Enum.count()

    # part 2
    # fold_all_and_print(points, folds)
    result
  end

  defp fold(points, [direction, coord]) do
    fold_line = String.to_integer(coord)

    Enum.map(points, fn {x, y} ->
      if direction == "x" do
        if x > fold_line, do: {fold_line - (x - fold_line), y}, else: {x, y}
      else
        if y > fold_line, do: {x, fold_line - (y - fold_line)}, else: {x, y}
      end
    end)
  end

  defp fold_all_and_print(points, folds) do
    folded = Enum.reduce(folds, points, &fold(&2, &1))
    width = Enum.max_by(folded, fn {x, _} -> x end) |> elem(0)
    height = Enum.max_by(folded, fn {_, y} -> y end) |> elem(1)

    for y <- -1..height do
      for x <- 0..width do
        if Enum.member?(folded, {x, y}), do: "#", else: " "
      end
    end
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.join("\n")
    |> IO.puts()
  end

  defp parse(file) do
    input = parse_input(:lines, file)
    points = parse_points(input)
    folds = parse_folds(input)
    {points, folds}
  end

  defp parse_folds(input) do
    input
    |> Enum.filter(&String.contains?(&1, "fold"))
    |> Enum.map(&(String.replace_prefix(&1, "fold along ", "") |> String.split("=")))
  end

  defp parse_points(input) do
    input
    |> Enum.take_while(&(not String.contains?(&1, "fold")))
    |> Enum.map(fn l ->
      String.split(l, ",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end
end
