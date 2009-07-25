(*
 * Copyright 2009  Dustin Sallings <dustin@spy.net>
 *)

let main () =
  let gearman = Gearman.connect Sys.argv.(1) 4730 in

  (* Register string functions *)
  Gearman.register gearman "uppercase" String.uppercase;
  Gearman.register gearman "lowercase" String.lowercase;
  Gearman.register gearman "capitalize" String.capitalize;
  Gearman.register gearman "uncapitalize" String.uncapitalize;
  Gearman.register gearman "escape" String.escaped;

  (* Work for a bit *)
  let rec loop n =
    if (n > 0) then (
      Gearman.do_work gearman;
      Printf.printf "Did one job %d more to go\n%!" (n - 1);
      loop (n - 1)) in
  loop 10;

  Gearman.shutdown gearman
;;

if !Sys.interactive then () else (main())
