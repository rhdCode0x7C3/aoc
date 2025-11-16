open Core
open Cmdliner
open Cmdliner.Term
open Aoc

type error =
  | Scaffold_err of Scaffold.error
  | Input_err of Input.error
  | Dispatcher_err of Solutions.Dispatcher.error
  | Puzzle_err of Puzzle.error

let run year day () =
  let open Result in
  let open Result.Let_syntax in
  let in_type = Puzzle.Input in
  let%bind puzzle =
    Puzzle.get in_type year day |> map_error ~f:(fun e -> Puzzle_err e)
  in
  let%bind () =
    Scaffold.scaffold puzzle |> map_error ~f:(fun e -> Scaffold_err e)
  in
  Ok ()

let handler res =
  match res () with
  | Ok () -> Aoc_cli.exit_ok
  | Error (Scaffold_err e) ->
      print_endline (Scaffold.error_to_string e);
      Aoc_cli.exit_err
  | Error (Input_err e) ->
      print_endline (Input.error_to_string e);
      Aoc_cli.exit_err
  | Error (Dispatcher_err e) ->
      print_endline (Solutions.Dispatcher.error_to_string e);
      Aoc_cli.exit_err
  | Error (Puzzle_err e) ->
      print_endline (Puzzle.error_to_string e);
      Aoc_cli.exit_err

let term =
  let year_term =
    Arg.(
      required & pos 0 (some string) None & info [] ~doc:"The year" ~docv:"YEAR")
  in
  let day_term =
    Arg.(
      required & pos 1 (some string) None & info [] ~doc:"The day" ~docv:"DAY")
  in
  const (fun year day -> handler (fun () -> run year day ()))
  $ year_term $ day_term

let info = Cmd.info ~doc:"Start working on a new puzzle solution" "start"
let cmd = Cmd.v info term
