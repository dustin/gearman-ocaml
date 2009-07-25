(*
 * Copyright 2009  Dustin Sallings <dustin@spy.net>
 *)

let main () =
  let gearman = Gearman.connect Sys.argv.(1) 4730 in
  let echo_res = Gearman.echo gearman Sys.argv.(2) in
  Printf.printf "Echo response:  %s\n" echo_res;
  Gearman.shutdown gearman
;;

if !Sys.interactive then () else (main())
