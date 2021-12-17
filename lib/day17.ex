defmodule Aoc2021.Day17 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day17.p1("inputs/day17.txt")
    11781
  """
  def p1(file) do
    [_, _, y_min, _] = parse(file)
    abs(y_min + 1) * div(abs(y_min), 2)
  end

  @doc """
    iex> Aoc2021.Day17.p2("inputs/day17.txt")
    4531
  """
  def p2(file) do
    [x_min, x_max, y_min, y_max] = parse(file)

    for x <- lower_bound_x(x_min)..x_max, y <- y_min..abs(y_min + 1), reduce: 0 do
      acc -> if hits?(0, 0, x, y, [x_min, x_max, y_min, y_max]), do: acc + 1, else: acc
    end
  end

  defp hits?(p_x, p_y, v_x, v_y, [x_min, x_max, y_min, y_max] = range) do
    cond do
      p_x > x_max or p_y < y_min -> false
      p_x < x_min or p_y > y_max -> hits?(p_x + v_x, p_y + v_y, new_v_x(v_x), v_y - 1, range)
      true -> true
    end
  end

  # The minimum x to reach the field is would be where the sum of integers for this value reaches the left bound
  # This is an approximation that guarantees to be less than this value but pretty close
  defp lower_bound_x(x_min), do: floor(:math.sqrt(x_min * 2))

  def new_v_x(0), do: 0
  def new_v_x(v_x), do: v_x - 1

  defp parse(file) do
    hd(parse_input(:lines, file))
    |> String.split([" ", "x=", "y=", ",", "target area:", ".."], trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
