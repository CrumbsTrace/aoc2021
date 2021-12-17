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

    for x <- 0..x_max, y <- y_min..abs(y_min + 1), reduce: 0 do
      acc -> if hits?({0, 0}, {x, y}, [x_min, x_max, y_min, y_max]), do: acc + 1, else: acc
    end
  end

  defp hits?({p_x, p_y} = p, v, [x_min, x_max, y_min, y_max] = range) do
    cond do
      p_x > x_max or p_y < y_min -> false
      p_x < x_min or p_y > y_max -> hits?(move(p, v), update_velocity(v), range)
      true -> true
    end
  end

  def move({p_x, p_y}, {v_x, v_y}), do: {p_x + v_x, p_y + v_y}

  def update_velocity({0, v_y}), do: {0, v_y - 1}
  def update_velocity({v_x, v_y}), do: {v_x - div(v_x, abs(v_x)), v_y - 1}

  defp parse(file) do
    hd(parse_input(:lines, file))
    |> String.split([" ", "x=", "y=", ",", "target area:", ".."], trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
