defmodule Aoc2021.Day18 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day18.p1("inputs/day18.txt")
    3359
  """
  def p1(file) do
    run(parse(file))
    |> magnitude()
  end

  @doc """
    iex> Aoc2021.Day18.p2("inputs/day18.txt")
    4616
  """
  def p2(file) do
    numbers = parse(file)

    all_combinations(numbers)
    |> Enum.map(&(run(&1) |> magnitude()))
    |> Enum.max()
  end

  defp run(numbers) do
    Enum.reduce(numbers, &explode_and_split([&2, &1]))
  end

  defp explode_and_split(input) do
    # IO.inspect(input, charlists: :as_lists)
    case explode(input, 0) do
      {result, nil} ->
        case check_split(result) do
          {result, nil} -> result
          {result, _} -> explode_and_split(result)
        end

      {result, _} ->
        explode_and_split(result)
    end
  end

  defp check_split(x) when is_integer(x) and x > 9, do: {split(x), :done}
  defp check_split(x) when is_integer(x), do: {x, nil}

  defp check_split([x, y]) do
    case check_split(x) do
      {_, nil} ->
        {result, progress} = check_split(y)
        {[x, result], progress}

      {result, _} ->
        {[result, y], :done}
    end
  end

  defp explode(n, _depth) when is_integer(n), do: {n, nil}
  defp explode(pair, 4), do: {pair, :explode}

  defp explode([x, y], depth) do
    {left, action} = explode(x, depth + 1)

    case action do
      :done -> {[left, y], :done}
      :explode -> {[0, add_left(y, left)], {:right, Enum.at(left, 0)}}
      {:right, _value} -> {[left, y], action}
      {:left, value} -> {[left, add_left(y, value)], :done}
      nil -> handle_right_explosion([x, y], depth)
    end
  end

  defp handle_right_explosion([left, right], depth) do
    {right, action} = explode(right, depth + 1)

    case action do
      :done -> {[left, right], :done}
      :explode -> {[add_right(left, right), 0], {:left, Enum.at(right, 1)}}
      {:right, value} -> {[add_right(left, value), right], :done}
      {:left, _value} -> {[left, right], action}
      nil -> {[left, right], nil}
    end
  end

  defp magnitude(x) when is_integer(x), do: x
  defp magnitude([x, y]), do: magnitude(x) * 3 + 2 * magnitude(y)

  defp add_right(l, list) when is_list(list), do: add_right(l, Enum.at(list, 0))
  defp add_right(n, value) when is_integer(n), do: n + value
  defp add_right([x, y], value), do: [x, add_right(y, value)]

  defp add_left(l, list) when is_list(list), do: add_left(l, Enum.at(list, 1))
  defp add_left(n, value) when is_integer(n), do: n + value
  defp add_left([x, y], value), do: [add_left(x, value), y]

  defp split(x) do
    left = div(x, 2)
    [left, x - left]
  end

  defp all_combinations([_]), do: []

  defp all_combinations([x | tail]) do
    combinations =
      for y <- tail, reduce: [] do
        acc -> [[x, y], [y, x] | acc]
      end

    combinations ++ all_combinations(tail)
  end

  defp parse(file) do
    parse_input(:lines, file)
    |> Enum.map(&(Code.eval_string(&1) |> elem(0)))
  end
end
