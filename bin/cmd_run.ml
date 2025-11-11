open Core
open Cmdliner
open Cmdliner.Term
open Aoc

type error =
  | Puzzle_err of Puzzle.error
  | Input_err of Input.error
  | Dispatcher_err of Solutions.Dispatcher.error

let run ?(samp = false) year day () =
  let open Result in
  let open Result.Let_syntax in
  let in_type =
    match samp with false -> Puzzle.Input | true -> Puzzle.Sample
  in
  let%bind puzzle =
    Puzzle.get in_type year day |> map_error ~f:(fun e -> Puzzle_err e)
  in
  let%bind p_in = Input.load puzzle |> map_error ~f:(fun e -> Input_err e) in
  let%bind solution =
    Solutions.Dispatcher.run puzzle p_in
    |> map_error ~f:(fun e -> Dispatcher_err e)
  in
  Format.print_solution solution;
  Ok ()

let handler res =
  match res () with
  | Ok () -> Aoc_cli.exit_ok
  | Error (Puzzle_err Puzzle.Year) ->
      print_endline "Invalid year.";
      Aoc_cli.exit_err
  | Error (Puzzle_err Puzzle.Day) ->
      print_endline "Invalid day.";
      Aoc_cli.exit_err
  | Error (Input_err Input.Channel) ->
      print_endline "Failed to open an input channel.";
      Aoc_cli.exit_err
  | Error (Input_err Input.Path) ->
      print_endline "Invalid path.";
      Aoc_cli.exit_err
  | Error (Dispatcher_err Solutions.Dispatcher.Dispatcher) ->
      print_endline "Solution not found.";
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
  let samp_term =
    Arg.(
      value & flag
      & info [ "s"; "sample" ] ~doc:"Use the sample input" ~docv:"SAMPLE")
  in
  const (fun samp year day -> handler (fun () -> run ~samp year day ()))
  $ samp_term $ year_term $ day_term

let info = Cmd.info ~doc:"Run a puzzle solution." "run"
let cmd = Cmd.v info term
