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

  Gearman.work_forever gearman;

  (* We never get here, but if we did, this is what we'd do *)
  Gearman.shutdown gearman
;;

if !Sys.interactive then () else (main())
