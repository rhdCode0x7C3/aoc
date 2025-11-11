open Core

type t = string
type error = Path | Channel

let make_path (puzzle : Puzzle.t) =
  let path_of_year y = Printf.sprintf "%4d" y in
  let path_of_day d = Printf.sprintf "d%02d" d in
  let path_of_in_type (in_type : Puzzle.in_type) =
    match in_type with Sample -> "sample" | Input -> "input"
  in
  try
    let path =
      Caml_unix.realpath
        (let local_path =
           String.concat
             [
               "puzzles/";
               path_of_year puzzle.year;
               "/inputs/";
               path_of_day puzzle.day;
               ".";
               path_of_in_type puzzle.in_type;
             ]
         in
         print_endline local_path;
         local_path)
    in
    Ok path
  with _ -> Error Path

let get path = try Ok (In_channel.read_all path) with _ -> Error Channel

let load puzzle =
  match make_path puzzle with Ok p -> get p | Error e -> Error e
