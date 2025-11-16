open Core

type error = Environment | Http

let error_to_string = function
  | Environment -> "The environment variable AOC_SESSION is not set."
  | Http -> "The http request went wrong."

let url (p : Puzzle.t) =
  Printf.sprintf "https://adventofcode.com/%d/day/%d/input" p.year p.day

let good_code c = c < 400

let session () =
  match Sys.getenv "AOC_SESSION" with
  | Some v -> Ok (Printf.sprintf "session=%s" v)
  | None -> Error Environment

let header () =
  let open Result in
  let open Result.Let_syntax in
  let%bind s = session () in
  Ok [ ("Cookie", s) ]

let get_input p =
  let open Result in
  let open Result.Let_syntax in
  let%bind h = header () in
  let%bind r =
    Ezcurl.get ~headers:h ~url:(url p) () |> map_error ~f:(fun _ -> Http)
  in
  if good_code r.Ezcurl_core.code then Ok r.body else Error Http
