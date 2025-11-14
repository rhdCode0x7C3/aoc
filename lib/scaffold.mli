open Core

type error = Environment | OC | File_exists

val init : Puzzle.t -> (unit, error) Result.t
