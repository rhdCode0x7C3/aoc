module type RUN = sig
  val solve : Input.t -> string option * string option
end
