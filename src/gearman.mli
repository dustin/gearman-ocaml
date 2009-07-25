(*
 * Copyright (c) 2009  Dustin Sallings <dustin@spy.net>
 *)

(**
  A gearman client for ocaml.

  {{:http://gearman.org/} http://gearman.org/}
*)

(** {1 Data Types} *)

(** The connection to gearman *)
type gearman_conn = {
    reader : in_channel;
    writer : out_channel;
    funcs : (string, (string -> string)) Hashtbl.t
  }

(** A response from a gearman server *)
type gearman_res = {
    cmd : int;
    data : string;
  }

(** {1 Functions} *)

(** {2 Connection Management} *)

(**
   Connection to a gearman server.

   @param hostname the server's hostname
   @param port the port number on the server (typically 4730)
*)
val connect : string -> int -> gearman_conn

(** Shut down a connection to a gearman server. *)
val shutdown : gearman_conn -> unit

(** {2 Worker Functions} *)

(**
   Register a function with the gearman server.

   @param func_name the name of the function to register
   @param f a function that takes input of some sort and returns output
*)
val register : gearman_conn -> string -> (string -> string) -> unit

(**
   Perform a single job.
*)
val do_work : gearman_conn -> unit

(**
   Loop forever performing jobs as they become available.
*)
val work_forever : gearman_conn -> unit

(** {2 Miscellaneous} *)

(** Gearman echo request (returns its input) *)
val echo : gearman_conn -> string -> string
