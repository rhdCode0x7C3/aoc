open Core

type error = Environment | Dispatcher | IC | OC

val error_to_string : error -> string

val edit : Puzzle.t -> (unit, error) Result.t
