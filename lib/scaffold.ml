open Core
open Core_unix

type error = Environment | OC | File_exists

let template =
  {|
module Solution : Aoc.Run.RUN = struct
  let solve _in = (None, None)
end

include Solution
  |}

let init (p : Puzzle.t) =
  let open Result in
  let open Result.Let_syntax in
  let is_valid path =
    match access path [ `Exists ] with
    | Error (Unix_error (ENOENT, _, _)) -> true
    | _ -> false
  in
  let filename = Printf.sprintf "y%4dd%02d.ml" p.year p.day in
  let%bind path =
    match Sys.getenv "PROJECT_ROOT_DIR" with
    | Some s -> Ok (s ^ "/solutions/" ^ filename)
    | None -> Error Environment
  in
  let comment =
    Printf.sprintf "(* %s *)\n(* Advent of Code Solution %4d Day %d)\n" filename
      p.year p.day
  in
  let file_content = comment ^ template in
  if is_valid path then
    try
      Out_channel.write_all path ~data:file_content;
      Ok ()
    with _ -> Error OC
  else Error File_exists
