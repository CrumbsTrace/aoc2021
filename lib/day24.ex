defmodule Aoc2021.Day24 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day24.p1("inputs/day24.txt", 51983999947999)
    567496
  """
  def p1(file, input_value) do
    instructions = parse(file)
    is_valid?(instructions, input_value)
  end

  defp is_valid?(instructions, input_value) do
    result =
      run(instructions, %{
        "x" => 0,
        "y" => 0,
        "z" => 0,
        "w" => 0,
        "d" => Integer.digits(input_value)
      })

    result == 0
  end

  defp run([], state), do: state["z"]

  defp run([instruction | rest], state) do
    run(rest, do_instruction(instruction, state))
  end

  def do_instruction(["inp", x], state),
    do: Map.replace!(state, x, hd(state["d"])) |> Map.update!("d", &tl(&1))

  def do_instruction(["mul", x, y], state), do: Map.update!(state, x, &(&1 * get(state, y)))
  def do_instruction(["add", x, y], state), do: Map.update!(state, x, &(&1 + get(state, y)))
  def do_instruction(["div", x, y], state), do: Map.update!(state, x, &div(&1, get(state, y)))
  def do_instruction(["mod", x, y], state), do: Map.update!(state, x, &rem(&1, get(state, y)))

  def do_instruction(["eql", x, y], state),
    do: Map.update!(state, x, &if(&1 == get(state, y), do: 1, else: 0))

  def get(state, "x"), do: state["x"]
  def get(state, "y"), do: state["y"]
  def get(state, "z"), do: state["z"]
  def get(state, "w"), do: state["w"]
  def get(_state, n), do: String.to_integer(n)

  defp parse(file) do
    parse_input(:lines, file)
    |> Enum.map(&String.split(&1, " ", trim: true))
  end
end
