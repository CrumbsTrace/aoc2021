defmodule Aoc2021.Helpers do
  def parse_number_input(file_name) do
    parse_input(:lines, file_name) |> Enum.map(&String.to_integer/1)
  end

  def parse_input(:lines, file_name), do: File.read!(file_name) |> String.split("\n", trim: true)

  def parse_input(:lines_spaces, file_name) do
    File.read!(file_name)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " "))
  end

  def parse_input(:lines_characters, file_name) do
    File.read!(file_name)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def unbits(bits), do: Integer.undigits(bits, 2)
end
