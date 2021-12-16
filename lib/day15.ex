defmodule Aoc2021.Day15 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day15.p1("inputs/day15.txt")
    390
  """
  def p1(file), do: run(file, false)

  @doc """
    iex> Aoc2021.Day15.p2("inputs/day15.txt")
    2814
  """
  def p2(file), do: run(file, true)

  defp run(file, times_five) do
    field = parse(file)
    width = tuple_size(elem(field, 1))
    height = tuple_size(field)

    start = {0, 0}

    finish = if(times_five, do: {width * 5 - 1, height * 5 - 1}, else: {width - 1, height - 1})
    grid = Grid.new(field, width, height)

    g_score_map = %{start => 0}

    priority_queue =
      Prioqueue.new([{start, euclidean_distance(start, finish)}], cmp_fun: &comparison/2)

    find_shortest_path(grid, g_score_map, priority_queue, finish, times_five)
  end

  defp find_shortest_path(grid, g_score_map, priority_queue, target, times_five) do
    {{position, _}, priority_queue} = Prioqueue.extract_min!(priority_queue)

    if position == target do
      g_score_map[position]
    else
      {priority_queue, g_score_map} =
        Enum.reduce(
          neighbors(grid, position, times_five),
          {priority_queue, g_score_map},
          fn neighbor, {priority_queue, g_score_map} ->
            new_g_score = g_score_map[position] + get_risk(grid, neighbor)
            old_g_score = g_score_map[neighbor]

            if old_g_score == nil or new_g_score < old_g_score do
              g_score_map =
                Map.update(g_score_map, neighbor, new_g_score, fn _ -> new_g_score end)

              f_score = new_g_score + euclidean_distance(neighbor, target)
              priority_queue = Prioqueue.insert(priority_queue, {neighbor, f_score})
              {priority_queue, g_score_map}
            else
              {priority_queue, g_score_map}
            end
          end
        )

      find_shortest_path(grid, g_score_map, priority_queue, target, times_five)
    end
  end

  defp neighbors(grid, {p_x, p_y}, times_five) do
    [{p_x - 1, p_y}, {p_x + 1, p_y}, {p_x, p_y - 1}, {p_x, p_y + 1}]
    |> Enum.reject(&out_of_bounds?(&1, grid.width, grid.height, times_five))
  end

  defp euclidean_distance({p_x, p_y}, {t_x, t_y}), do: abs(t_y - p_y) + abs(t_x - p_x)

  defp out_of_bounds?({x, y}, m_w, m_h, times_five) do
    if times_five do
      x < 0 or x >= 5 * m_w or y < 0 or y >= 5 * m_h
    else
      x < 0 or x >= m_w or y < 0 or y >= m_h
    end
  end

  defp get_risk(grid, {x, y}) do
    new_x = rem(x, grid.width)
    new_y = rem(y, grid.height)
    offset = div(x, grid.width) + div(y, grid.height)
    flow_over(elem(elem(grid.field, new_y), new_x) + offset)
  end

  defp flow_over(risk) when risk < 10, do: risk
  defp flow_over(risk), do: flow_over(risk - 9)

  defp parse(file) do
    parse_input(:lines, file)
    |> Enum.map(fn line ->
      String.split(line, "", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> List.to_tuple()
  end

  defp comparison({_, a}, {_, b}) when a < b, do: :lt
  defp comparison({_, a}, {_, b}) when a == b, do: :eq
  defp comparison({_, _a}, {_, _b}), do: :gt
end

defmodule Grid do
  defstruct [:field, :width, :height]

  def new(field, width, height) do
    %Grid{
      field: field,
      width: width,
      height: height
    }
  end
end
