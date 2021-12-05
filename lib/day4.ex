defmodule Aoc2021.Day4 do
  import Aoc2021.Helpers

  @spec p1(binary()) :: number()
  @doc """
    iex> Aoc2021.Day4.p1("inputs/day4.txt")
    89001
  """
  def p1(file) do
    parse_input(:lines, file)
    |> BingoSystem.create()
    |> BingoSystem.run_till_winner()
  end

  @spec p2(binary()) :: number()
  @doc """
      iex> Aoc2021.Day4.p2("inputs/day4.txt")
      7296
  """
  def p2(file) do
    parse_input(:lines, file)
    |> BingoSystem.create()
    |> BingoSystem.find_last_winning_board()
  end
end

defmodule BingoSystem do
  @enforce_keys [:draw_numbers, :boards]
  defstruct [:draw_numbers, :boards]

  @type t :: %__MODULE__{
          draw_numbers: [non_neg_integer],
          boards: [Board.t()]
        }

  @spec create([binary()]) :: BingoSystem.t()
  def create(input) do
    draw_numbers =
      Enum.at(input, 0)
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    boards = Board.parse_boards(Enum.drop(input, 1), [])
    %BingoSystem{draw_numbers: draw_numbers, boards: boards}
  end

  @spec find_last_winning_board(BingoSystem.t()) :: non_neg_integer()
  def find_last_winning_board(%BingoSystem{draw_numbers: [n | draws], boards: boards}) do
    new_boards = Enum.map(boards, fn board -> Board.update_board(board, n) end)

    losing_boards = Enum.filter(new_boards, fn board -> not Board.check_if_win(board, n) end)

    if Enum.count(losing_boards) > 0 do
      find_last_winning_board(%BingoSystem{draw_numbers: draws, boards: losing_boards})
    else
      Board.calculate_score(hd(new_boards), n)
    end
  end

  @spec run_till_winner(BingoSystem.t()) :: number()
  def run_till_winner(%BingoSystem{draw_numbers: [n | draws], boards: boards}) do
    new_boards = Enum.map(boards, fn board -> Board.update_board(board, n) end)

    winning_board = Enum.find(new_boards, fn board -> Board.check_if_win(board, n) end)

    if winning_board == nil do
      run_till_winner(%BingoSystem{draw_numbers: draws, boards: new_boards})
    else
      Board.calculate_score(winning_board, n)
    end
  end
end

defmodule Board do
  @enforce_keys [:number_map, :row_visits, :column_visits, :visited]
  defstruct [:number_map, :row_visits, :column_visits, :visited]

  @type t :: %__MODULE__{
          number_map: %{non_neg_integer() => {non_neg_integer(), non_neg_integer()}},
          row_visits: %{non_neg_integer() => non_neg_integer()},
          column_visits: %{non_neg_integer() => non_neg_integer()},
          visited: %MapSet{}
        }

  @spec parse_boards([binary()], [Board.t()]) :: [Board.t()]
  def parse_boards([], result), do: result

  def parse_boards(input, result) do
    squares = Enum.take(input, 5) |> Enum.with_index()

    number_map =
      Enum.reduce(squares, Map.new(), fn {row, idx}, map -> update_map_for_row(row, map, idx) end)

    board = %Board{
      number_map: number_map,
      row_visits: initialize_visits(),
      column_visits: initialize_visits(),
      visited: MapSet.new()
    }

    parse_boards(Enum.drop(input, 5), [board | result])
  end

  @spec initialize_visits() :: %{non_neg_integer() => non_neg_integer()}
  defp initialize_visits(), do: for(x <- 0..4, do: {x, 0}) |> Map.new()

  @spec update_map_for_row(
          binary(),
          %{non_neg_integer() => {non_neg_integer(), non_neg_integer()}},
          non_neg_integer()
        ) :: %{non_neg_integer() => {non_neg_integer(), non_neg_integer()}}
  def update_map_for_row(row, number_map, y) do
    numbers =
      String.split(row, " ", trim: true) |> Enum.map(&String.to_integer/1) |> Enum.with_index()

    Enum.reduce(numbers, number_map, fn {number, idx}, map ->
      Map.put_new(map, number, {idx, y})
    end)
  end

  @spec update_board(Board.t(), non_neg_integer()) :: Board.t()
  def update_board(board, draw_number) do
    square = Map.get(board.number_map, draw_number)

    if square == nil do
      board
    else
      {x, y} = square
      column_visits = Map.update!(board.column_visits, x, &(&1 + 1))
      row_visits = Map.update!(board.row_visits, y, &(&1 + 1))

      %Board{
        board
        | column_visits: column_visits,
          row_visits: row_visits,
          visited: MapSet.put(board.visited, draw_number)
      }
    end
  end

  @spec check_if_win(Board.t(), non_neg_integer()) :: boolean()
  def check_if_win(board, draw_number) do
    square = Map.get(board.number_map, draw_number)
    square != nil and winning_row_or_column?(board, square)
  end

  @spec calculate_score(Board.t(), non_neg_integer()) :: non_neg_integer()
  def calculate_score(board, last_number) do
    all_numbers = Map.keys(board.number_map)

    remaining_numbers =
      Enum.filter(all_numbers, fn number -> not MapSet.member?(board.visited, number) end)

    Enum.sum(remaining_numbers) * last_number
  end

  @spec winning_row_or_column?(Board.t(), {non_neg_integer(), non_neg_integer()}) :: boolean()
  def winning_row_or_column?(board, {x, y}) do
    columns_visit_count = Map.get(board.column_visits, x)
    row_visit_count = Map.get(board.row_visits, y)

    columns_visit_count == 5 or row_visit_count == 5
  end
end
