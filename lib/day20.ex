defmodule Aoc2021.Day20 do
  import Aoc2021.Helpers

  @doc """
    iex> Aoc2021.Day20.p1("inputs/day20.txt")
    5573
  """
  def p1(file), do: run(file, 2)

  @doc """
    iex> Aoc2021.Day20.p2("inputs/day20.txt")
    53790
  """
  def p2(file), do: run(file, 50)

  defp run(file, max_cycle) do
    {enhancement_lookup, image} = parse(file)

    run(image, enhancement_lookup, nil, 0, max_cycle, false)
    |> MapSet.size()
  end

  defp run(image, _, _, max_cycle, max_cycle, _), do: image

  defp run(image, enhancement_lookup, old_bounds, current_cycle, max_cycle, infinity_is_on) do
    bounds = determine_bounds(image)
    image = update_image(image, enhancement_lookup, old_bounds, bounds, infinity_is_on)
    infinity_is_on = enhancement_lookup[0] and not infinity_is_on
    run(image, enhancement_lookup, bounds, current_cycle + 1, max_cycle, infinity_is_on)
  end

  defp update_image(image, enhancement_lookup, old_bounds, bounds, infinity_is_on) do
    {x_min, x_max, y_min, y_max} = bounds

    Enum.reduce(y_min..y_max, MapSet.new(), fn y, new_image ->
      Enum.reduce(
        x_min..x_max,
        new_image,
        &update_point({&1, y}, &2, enhancement_lookup, image, old_bounds, infinity_is_on)
      )
    end)
  end

  defp update_point(point, image, enhancement_lookup, old_image, old_bounds, infinity_is_on) do
    index = determine_index(point, old_image, old_bounds, infinity_is_on)

    if enhancement_lookup[index], do: MapSet.put(image, point), else: image
  end

  defp determine_index(point, old_image, old_bounds, infinity_is_on) do
    Enum.map(section(point), fn neighbor ->
      if MapSet.member?(old_image, neighbor) or
           (infinity_is_on and outside_bounds?(old_bounds, neighbor)),
         do: 1,
         else: 0
    end)
    |> Integer.undigits(2)
  end

  defp outside_bounds?({x_min, x_max, y_min, y_max}, {x, y}) do
    x < x_min or x > x_max or y < y_min or y > y_max
  end

  defp determine_bounds(image) do
    {{x_min, _}, {x_max, _}} = Enum.min_max_by(image, fn {x, _} -> x end)
    {{_, y_min}, {_, y_max}} = Enum.min_max_by(image, fn {_, y} -> y end)
    {x_min - 1, x_max + 1, y_min - 1, y_max + 1}
  end

  defp section({x, y}),
    do: [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ]

  defp parse(file) do
    [enhancement_string | grid] = parse_input(:lines, file)

    enhancement_lookup =
      String.split(enhancement_string, "", trim: true)
      |> Enum.with_index()
      |> Map.new(fn {c, idx} -> {idx, c == "#"} end)

    grid =
      Enum.map(grid, fn line ->
        String.split(line, "", trim: true)
        |> Enum.with_index()
        |> Enum.filter(fn {c, _idx} -> c == "#" end)
      end)
      |> Enum.with_index()

    image =
      Enum.reduce(grid, MapSet.new(), fn {line, y}, image ->
        Enum.reduce(line, image, fn {_, x}, image -> MapSet.put(image, {x, y}) end)
      end)

    {enhancement_lookup, image}
  end
end
