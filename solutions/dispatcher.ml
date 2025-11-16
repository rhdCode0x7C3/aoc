type error = Dispatcher

let error_to_string = function
  | Dispatcher -> "Couldn't find the solution in the dispatcher."

let run (puzzle : Aoc.Puzzle.t) (input : Aoc.Input.t) =
  match (puzzle.year, puzzle.day) with
  | 2024, 01 -> Ok (Y2024d01.solve input)
  | 2024, 02 -> Ok (Y2024d02.solve input)
| 2024, 03 -> Ok (Y2024d03.solve input)
  (* ADD SOLUTIONS HERE *)
  | _ -> Error Dispatcher
