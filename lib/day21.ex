defmodule Aoc2021.Day21 do
  @doc """
    iex> Aoc2021.Day21.p1(10, 3)
    742257
  """
  def p1(p1, p2) do
    play(p1, p2, 0, 0, 1, 0)
  end

  @doc """
    iex> Aoc2021.Day21.p2(10, 3)
    93726416205179
  """
  def p2(p1, p2) do
    {p1_wins, p1_not_wins} = ways_to_win_or_not_win({%{}, %{}}, p1, 0, 0, 1)
    {p2_wins, p2_not_wins} = ways_to_win_or_not_win({%{}, %{}}, p2, 0, 0, 1)

    wins_p1 =
      Enum.map(p1_wins, fn {turns, freq} -> freq * (p2_not_wins[turns - 1] || 0) end)
      |> Enum.sum()

    wins_p2 =
      Enum.map(p2_wins, fn {turns, freq} -> freq * (p1_not_wins[turns] || 0) end)
      |> Enum.sum()

    if wins_p1 > wins_p2, do: wins_p1, else: wins_p2
  end

  defp ways_to_win_or_not_win({wins, not_wins}, _, score, length, multiplier) when score >= 21,
    do: {Map.update(wins, length, multiplier, &(&1 + multiplier)), not_wins}

  defp ways_to_win_or_not_win({endings, not_wins}, pos, score, length, multiplier) do
    not_wins = Map.update(not_wins, length, multiplier, &(&1 + multiplier))

    {endings, not_wins}
    |> ways_to_win_or_not_win(over(pos + 3), score + over(pos + 3), length + 1, multiplier)
    |> ways_to_win_or_not_win(over(pos + 4), score + over(pos + 4), length + 1, multiplier * 3)
    |> ways_to_win_or_not_win(over(pos + 5), score + over(pos + 5), length + 1, multiplier * 6)
    |> ways_to_win_or_not_win(over(pos + 6), score + over(pos + 6), length + 1, multiplier * 7)
    |> ways_to_win_or_not_win(over(pos + 7), score + over(pos + 7), length + 1, multiplier * 6)
    |> ways_to_win_or_not_win(over(pos + 8), score + over(pos + 8), length + 1, multiplier * 3)
    |> ways_to_win_or_not_win(over(pos + 9), score + over(pos + 9), length + 1, multiplier)
  end

  defp over(position), do: over(position, 10)
  defp over(position, over) when position > over, do: over(position - over, over)
  defp over(position, _over), do: position

  def play(p1, p2, p1_score, p2_score, die, die_roll_count) do
    rolls = [over(die, 100), over(die + 1, 100), over(die + 2, 100)]
    die = over(die + 3)
    p1 = over(p1 + Enum.sum(rolls))
    p1_score = p1_score + p1

    if p1_score >= 1000 do
      p2_score * (die_roll_count + 3)
    else
      rolls = [over(die, 100), over(die + 1, 100), over(die + 2, 100)]
      die = over(die + 3)
      p2 = over(p2 + Enum.sum(rolls))
      p2_score = p2_score + p2

      if p2_score >= 1000 do
        p1_score * (die_roll_count + 6)
      else
        play(p1, p2, p1_score, p2_score, die, die_roll_count + 6)
      end
    end
  end
end
