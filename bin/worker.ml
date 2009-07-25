(*
 * Copyright 2009  Dustin Sallings <dustin@spy.net>
 *)

let test_func s =
  String.capitalize s

let main () =
  let gearman = Gearman.connect Sys.argv.(1) 4730 in

  Gearman.register gearman "test" test_func;
  Gearman.do_work gearman;

  Gearman.shutdown gearman
;;

if !Sys.interactive then () else (main())
