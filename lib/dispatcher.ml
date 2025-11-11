open Core

module IntPair = struct
  include Tuple.Comparator (Int) (Int)
  include Tuple.Comparable (Int) (Int)
end

let solutions =
  Map.of_alist
    (module IntPair)
    [ ((2024, 01), (module Solutions.Y2024d01 : Run.RUN)) ]
