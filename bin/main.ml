open Cmdliner

let cmd =
  let default = Term.(ret (const (`Help (`Auto, None)))) in
  Cmd.group (Cmd.info "aoc") ~default @@ [ Cmd_run.cmd; Cmd_start.cmd ]

let main = Cmd.eval' cmd
let () = if !Sys.interactive then () else exit main
