open Core

type error =
  | Generate_solution of Generate_solution.error
  | Edit_dispatcher of Edit_dispatcher.error
  | Http of Http.error
  | Input of Input.error

  val error_to_string : error -> string

val scaffold : Puzzle.t -> (unit, error) Result.t
