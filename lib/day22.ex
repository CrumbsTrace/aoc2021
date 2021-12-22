defmodule Aoc2021.Day22 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day22.p1("inputs/day22.txt")
    567496
  """
  def p1(file), do: run(file, [-50, 50, -50, 50, -50, 50])

  @doc """
    iex> Aoc2021.Day22.p2("inputs/day22.txt")
    1355961721298916
  """
  def p2(file), do: run(file, nil)

  defp run(file, bounds), do: parse(file) |> handle_cubes(bounds) |> get_total_volume()

  defp get_total_volume(cubes), do: Enum.map(cubes, &Cube.volume/1) |> Enum.sum()

  defp handle_cubes(input_cubes, bounds) do
    Enum.reduce(input_cubes, [], fn cube, cubes ->
      input = if bounds != nil, do: overlap(cube.dims, bounds), else: cube.dims
      cubes = Enum.map(cubes, &cut(&1, input))

      if cube.on and length(input) == 6, do: [Cube.new(input) | cubes], else: cubes
    end)
  end

  defp cut(cube, input) do
    overlap = overlap(cube.dims, input)

    case length(overlap) == 6 do
      true -> Cube.update_cuts(cube, [Cube.new(overlap) | Enum.map(cube.cuts, &cut(&1, overlap))])
      false -> cube
    end
  end

  defp overlap([c1, c2 | _], [d1, d2 | _]) when c2 < d1 or c1 > d2, do: [nil]
  defp overlap([c1, c2 | cs], [d1, d2 | ds]), do: [max(c1, d1), min(c2, d2) | overlap(cs, ds)]
  defp overlap(_, _), do: []

  defp parse(file) do
    parse_input(:lines, file)
    |> Enum.map(fn line ->
      [state | dimensions] = String.split(line, [" ", "x=", ",y=", ",z=", ".."], trim: true)
      dimensions = Enum.map(dimensions, &String.to_integer/1)
      Cube.new(dimensions, state == "on")
    end)
  end
end

defmodule Cube do
  defstruct [:on, :dims, :cuts]

  def new(dims, on \\ false), do: %Cube{on: on, dims: dims, cuts: []}

  def update_cuts(cube, cuts), do: %Cube{cube | cuts: cuts}

  def volume(cube) do
    [x1, x2, y1, y2, z1, z2] = cube.dims
    (x2 - x1 + 1) * (y2 - y1 + 1) * (z2 - z1 + 1) - Enum.sum(Enum.map(cube.cuts, &volume/1))
  end
end
