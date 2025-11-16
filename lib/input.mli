open Core

type t = string

type error = Path | IC | OC | File_exists of string | Environment
val error_to_string : error -> string

val load : Puzzle.t -> (t, error) Result.t

val write : Puzzle.t -> string -> (unit, error) Result.t
