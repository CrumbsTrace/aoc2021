defmodule Aoc2021.Helpers do
  def parse_number_input(file_name) do
    parse_input(:line, file_name) |> Enum.map(&String.to_integer/1)
  end

  def parse_input(:line, file_name), do: File.read!(file_name) |> String.split("\n", trim: true)
end
