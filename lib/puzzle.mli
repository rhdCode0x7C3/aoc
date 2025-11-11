type in_type = Sample | Input
type t = { year : int; day : int; in_type : in_type }
type error = Year | Day

val get : in_type -> string -> string -> (t, error) Result.t
