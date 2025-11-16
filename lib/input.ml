open Core
open Core_unix

type t = string
type error = Path | IC | OC | File_exists of string | Environment

let error_to_string = function
  | Path -> "Path resoluion failed."
  | IC -> "Failed to open an input channel."
  | OC -> "Failed to open an output channel."
  | Environment -> "The environment variable PROJECT_ROOT_DIR is not set"
  | File_exists s -> Printf.sprintf "The file %s already exists" s

let make_path (puzzle : Puzzle.t) =
  let path_of_year y = Printf.sprintf "%4d" y in
  let path_of_day d = Printf.sprintf "d%02d" d in
  let path_of_in_type (in_type : Puzzle.in_type) =
    match in_type with Sample -> "sample" | Input -> "input"
  in
  let project_root =
    match Sys.getenv "PROJECT_ROOT_DIR" with
    | Some s -> Ok s
    | None -> Error Environment
  in
  let open Result in
  let open Result.Let_syntax in
  let%bind root = project_root in
  let path =
    String.concat
      [
        root;
        "/puzzles/";
        path_of_year puzzle.year;
        "/inputs/";
        path_of_day puzzle.day;
        ".";
        path_of_in_type puzzle.in_type;
      ]
  in
  print_endline path;
  Ok path

let get path = try Ok (In_channel.read_all path) with _ -> Error IC

let load puzzle =
  match make_path puzzle with Ok p -> get p | Error e -> Error e

let write p s =
  let open Result in
  let open Result.Let_syntax in
  let file_exists p =
    match access p [ `Exists ] with Ok _ -> true | _ -> false
  in
  let%bind path = make_path p in
  if not (file_exists path) then
    try Ok (Out_channel.write_all path ~data:s) with _ -> Error OC
  else Error (File_exists path)
