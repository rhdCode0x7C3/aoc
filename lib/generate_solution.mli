open Core

type error = Environment | OC | File_exists

val error_to_string : error -> string
val gen : Puzzle.t -> (unit, error) Result.t
