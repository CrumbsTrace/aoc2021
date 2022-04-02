Benchee.run(
  %{
    "Day1" => fn -> Aoc2021.Day1.p1("inputs/day1.txt"); Aoc2021.Day1.p2("inputs/day1.txt") end,
    "Day2" => fn -> Aoc2021.Day2.p1("inputs/day2.txt"); Aoc2021.Day2.p2("inputs/day2.txt") end,
    "Day3" => fn -> Aoc2021.Day3.p1("inputs/day3.txt"); Aoc2021.Day3.p2("inputs/day3.txt") end,
    "Day4" => fn -> Aoc2021.Day4.p1("inputs/day4.txt"); Aoc2021.Day4.p2("inputs/day4.txt") end,
    "Day5" => fn -> Aoc2021.Day5.p1("inputs/day5.txt"); Aoc2021.Day5.p2("inputs/day5.txt") end,
    "Day6" => fn -> Aoc2021.Day6.p1("inputs/day6.txt"); Aoc2021.Day6.p2("inputs/day6.txt") end,
    "Day7" => fn -> Aoc2021.Day7.p1("inputs/day7.txt"); Aoc2021.Day7.p2("inputs/day7.txt") end,
    "Day8" => fn -> Aoc2021.Day8.p1("inputs/day8.txt"); Aoc2021.Day8.p2("inputs/day8.txt") end,
    "Day9" => fn -> Aoc2021.Day9.p1("inputs/day9.txt"); Aoc2021.Day9.p2("inputs/day9.txt") end,
    "Day10" => fn -> Aoc2021.Day10.p1("inputs/day10.txt"); Aoc2021.Day10.p2("inputs/day10.txt") end,
    "Day11" => fn -> Aoc2021.Day11.p1("inputs/day11.txt"); Aoc2021.Day11.p2("inputs/day11.txt") end,
    "Day12" => fn -> Aoc2021.Day12.p1("inputs/day12.txt"); Aoc2021.Day12.p2("inputs/day12.txt") end,
    "Day13" => fn -> Aoc2021.Day13.p1("inputs/day13.txt") end,
    "Day14" => fn -> Aoc2021.Day14.p1("inputs/day14.txt"); Aoc2021.Day14.p2("inputs/day14.txt") end,
    "Day15" => fn -> Aoc2021.Day15.p1("inputs/day15.txt"); Aoc2021.Day15.p2("inputs/day15.txt") end,
    "Day16" => fn -> Aoc2021.Day16.p1("inputs/day16.txt"); Aoc2021.Day16.p2("inputs/day16.txt") end,
    "Day17" => fn -> Aoc2021.Day17.p1("inputs/day17.txt"); Aoc2021.Day17.p2("inputs/day17.txt") end,
    "Day18" => fn -> Aoc2021.Day18.p1("inputs/day18.txt"); Aoc2021.Day18.p2("inputs/day18.txt") end,
    "Day19" => fn -> Aoc2021.Day19.p1("inputs/day19.txt"); Aoc2021.Day19.p2("inputs/day19.txt") end,
    "Day20" => fn -> Aoc2021.Day20.p1("inputs/day20.txt"); Aoc2021.Day20.p2("inputs/day20.txt") end,
    "Day21" => fn -> Aoc2021.Day21.p1(10, 3); Aoc2021.Day21.p2(10, 3) end,
    "Day22" => fn -> Aoc2021.Day22.p1("inputs/day22.txt"); Aoc2021.Day22.p2("inputs/day22.txt") end,
    "Day25" => fn -> Aoc2021.Day25.p1("inputs/day25.txt") end
  },
  warmup: 2,
  time: 3,
)

# Benchee.run(
#   %{
#     "All days" => fn ->
#       Aoc2021.Day1.p1("inputs/day1.txt")
#       Aoc2021.Day1.p2("inputs/day1.txt")
#       Aoc2021.Day2.p1("inputs/day2.txt")
#       Aoc2021.Day2.p2("inputs/day2.txt")
#       Aoc2021.Day3.p1("inputs/day3.txt")
#       Aoc2021.Day3.p2("inputs/day3.txt")
#       Aoc2021.Day4.p1("inputs/day4.txt")
#       Aoc2021.Day4.p2("inputs/day4.txt")
#       Aoc2021.Day5.p1("inputs/day5.txt")
#       Aoc2021.Day5.p2("inputs/day5.txt")
#       Aoc2021.Day6.p1("inputs/day6.txt")
#       Aoc2021.Day6.p2("inputs/day6.txt")
#       Aoc2021.Day7.p1("inputs/day7.txt")
#       Aoc2021.Day7.p2("inputs/day7.txt")
#       Aoc2021.Day8.p1("inputs/day8.txt")
#       Aoc2021.Day8.p2("inputs/day8.txt")
#       Aoc2021.Day9.p1("inputs/day9.txt")
#       Aoc2021.Day9.p2("inputs/day9.txt")
#       Aoc2021.Day10.p1("inputs/day10.txt")
#       Aoc2021.Day10.p2("inputs/day10.txt")
#       Aoc2021.Day11.p1("inputs/day11.txt")
#       Aoc2021.Day11.p2("inputs/day11.txt")
#       Aoc2021.Day12.p2("inputs/day12.txt")
#       Aoc2021.Day13.p1("inputs/day13.txt")
#       Aoc2021.Day14.p1("inputs/day14.txt")
#       Aoc2021.Day14.p2("inputs/day14.txt")
#       Aoc2021.Day15.p1("inputs/day15.txt")
#       Aoc2021.Day15.p2("inputs/day15.txt")
#       Aoc2021.Day16.p1("inputs/day16.txt")
#       Aoc2021.Day16.p2("inputs/day16.txt")
    # "Day21 p1" => fn -> Aoc2021.Day21.p1(10, 3) end,
    # "Day21 p2" => fn -> Aoc2021.Day21.p2(10, 3) end,
#     end,
#   }, warmup: 2, time: 20, memory_time: 1)
