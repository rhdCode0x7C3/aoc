open Core

type error =
  | Generate_solution of Generate_solution.error
  | Edit_dispatcher of Edit_dispatcher.error
  | Http of Http.error
  | Input of Input.error

let error_to_string = function
  | Generate_solution e -> Generate_solution.error_to_string e
  | Edit_dispatcher e -> Edit_dispatcher.error_to_string e
  | Http e -> Http.error_to_string e
  | Input e -> Input.error_to_string e

let scaffold (p : Puzzle.t) =
  let open Result in
  let open Result.Let_syntax in
  let%bind p_in = Http.get_input p |> map_error ~f:(fun e -> Http e) in
  let%bind _ = Input.write p p_in |> map_error ~f:(fun e -> Input e) in
  let%bind _ =
    Generate_solution.gen p |> map_error ~f:(fun e -> Generate_solution e)
  in
  let%bind _ =
    Edit_dispatcher.edit p |> map_error ~f:(fun e -> Edit_dispatcher e)
  in
  Ok ()
