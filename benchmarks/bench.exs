Benchee.run(
  %{
    "Day1 p1" => fn -> Aoc2021.Day1.p1("inputs/day1.txt") end,
    "Day1 p2" => fn -> Aoc2021.Day1.p2("inputs/day1.txt") end,
    "Day2 p1" => fn -> Aoc2021.Day2.p1("inputs/day2.txt") end,
    "Day2 p2" => fn -> Aoc2021.Day2.p2("inputs/day2.txt") end,
    "Day3 p1" => fn -> Aoc2021.Day3.p1("inputs/day3.txt") end,
    "Day3 p2" => fn -> Aoc2021.Day3.p2("inputs/day3.txt") end,
    "Day4 p1" => fn -> Aoc2021.Day4.p1("inputs/day4.txt") end,
    "Day4 p2" => fn -> Aoc2021.Day4.p2("inputs/day4.txt") end,
    "Day5 p1" => fn -> Aoc2021.Day5.p1("inputs/day5.txt") end,
    "Day5 p2" => fn -> Aoc2021.Day5.p2("inputs/day5.txt") end,
    "Day6 p1" => fn -> Aoc2021.Day6.p1("inputs/day6.txt") end,
    "Day6 p2" => fn -> Aoc2021.Day6.p2("inputs/day6.txt") end,
  }, warmup: 2, time: 5, memory_time: 1) 
