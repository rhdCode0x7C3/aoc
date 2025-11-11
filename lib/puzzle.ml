open Core

type in_type = Sample | Input
type t = { year : int; day : int; in_type : in_type }
type error = Year | Day

let make_year year =
  match Int.of_string_opt year with
  | Some y -> if y < 100 then Ok (2000 + y) else Ok y
  | None -> Error Year

let make_day day =
  match Int.of_string_opt day with
  | Some d -> if d < 31 then Ok d else Error Day
  | None -> Error Day

let get in_type year day =
  let open Result.Let_syntax in
  let%bind year = make_year year in
  let%bind day = make_day day in
  Ok { year; day; in_type }
