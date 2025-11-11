open Core

type t = string
type error = Path | Channel

val load : Puzzle.t -> (t, error) Result.t
