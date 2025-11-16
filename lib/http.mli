open Core

type error = Environment | Http

val error_to_string : error -> string
val get_input : Puzzle.t -> (string, error) Result.t
