let print_solution sol =
  let a, b = sol in
  let string_of_part p = match p with Some s -> s | None -> "Unsolved" in
  Printf.printf "Part A: %s\n" (string_of_part a);
  Printf.printf "Part B: %s\n" (string_of_part b)
