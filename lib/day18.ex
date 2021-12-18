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
    Enum.reduce(numbers, &explode_till_no_action([&2, &1]))
  end

  defp explode_till_no_action(input) do
    # IO.inspect(input, charlists: :as_lists)
    {result, action} = explode(input, 0, false)

    if action == nil do
      {result, action} = check_split(result)

      if action == nil do
        result
      else
        explode_till_no_action(result)
      end
    else
      explode_till_no_action(result)
    end
  end

  defp check_split(x) when is_integer(x) and x > 9, do: {split(x), :done}
  defp check_split(x) when is_integer(x), do: {x, nil}

  defp check_split([x, y]) do
    {result, progress} = check_split(x)

    if progress == nil do
      {result, progress} = check_split(y)
      {[x, result], progress}
    else
      {[result, y], :done}
    end
  end

  defp explode(n, _depth, _) when is_integer(n), do: {n, nil}
  defp explode(pair, 4, _), do: {pair, :explode}

  defp explode([x, y], depth, allow_splits) do
    {left, action} = explode(x, depth + 1, allow_splits)

    case action do
      :done ->
        {[left, y], :done}

      :explode ->
        {[0, add_left(y, Enum.at(left, 1))], {:add_right_most, Enum.at(left, 0)}}

      {:add_right_most, _value} ->
        {[left, y], action}

      {:add_left_most, value} ->
        {[left, add_left(y, value)], :done}

      nil ->
        {right, action} = explode(y, depth + 1, allow_splits)

        case action do
          :done ->
            {[left, right], :done}

          :explode ->
            {[add_right(left, Enum.at(right, 0)), 0], {:add_left_most, Enum.at(right, 1)}}

          {:add_right_most, value} ->
            {[add_right(left, value), right], :done}

          {:add_left_most, _value} ->
            {[left, right], action}

          nil ->
            {[left, right], nil}
        end
    end
  end

  defp magnitude(x) when is_integer(x), do: x
  defp magnitude([x, y]), do: magnitude(x) * 3 + 2 * magnitude(y)

  defp add_right(n, value) when is_integer(n), do: n + value
  defp add_right([x, y], value), do: [x, add_right(y, value)]

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
