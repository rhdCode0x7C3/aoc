open Core

type error = Environment | Dispatcher | IC | OC

let error_to_string = function
  | Environment -> "Environment variable PROJECT_ROOT_DIR is not set."
  | Dispatcher -> "This solution is already implemented."
  | IC -> "Failed to open an input channel."
  | OC -> "Failed to open an output channel."

let make_line year day =
  Printf.sprintf "| %4d, %02d -> Ok (Y%4dd%02d.solve input)" year day year day

let get_path () =
  match Sys.getenv "PROJECT_ROOT_DIR" with
  | Some s -> Ok (s ^ "/solutions/dispatcher.ml")
  | None -> Error Environment

let read () =
  let open Result in
  let open Result.Let_syntax in
  let%bind path = get_path () in
  try Ok (In_channel.read_lines path) with _ -> Error IC

let write lines =
  let open Result in
  let open Result.Let_syntax in
  let%bind path = get_path () in
  try Ok (Out_channel.write_lines path lines) with _ -> Error OC

let check_dispatcher lines s =
  match
    List.find lines ~f:(fun line -> String.is_substring ~substring:s line)
  with
  | None -> Ok ()
  | Some _ -> Error Dispatcher

let insert l e c =
  let rec insert_inner l e c acc =
    match l with
    | [] -> acc
    | h :: t ->
        if c h then insert_inner t e c (h :: e :: acc)
        else insert_inner t e c (h :: acc)
  in
  List.rev (insert_inner l e c [])

let edit (p : Puzzle.t) =
  let dispatcher =
    let open Result in
    let open Result.Let_syntax in
    let%bind l = read () in
    let e = make_line p.year p.day in
    let c =
     fun s -> String.is_substring ~substring:"(* ADD SOLUTIONS HERE *)" s
    in
    match check_dispatcher l e with
    | Ok () -> Ok (insert l e c)
    | Error e -> Error e
  in
  match dispatcher with Ok d -> write d | Error e -> Error e
