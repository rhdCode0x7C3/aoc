type error = Dispatcher

let run (puzzle : Aoc.Puzzle.t) (input : Aoc.Input.t) =
  match (puzzle.year, puzzle.day) with
  | 2024, 01 -> Ok (Y2024d01.solve input)
  | 2024, 02 -> Ok (Y2024d02.solve input)
  | _ -> Error Dispatcher
