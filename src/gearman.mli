(*
 * Copyright (c) 2009  Dustin Sallings <dustin@spy.net>
 *)

(**
  A gearman client for ocaml.

  {{:http://gearman.org/} http://gearman.org/}
*)

type gearman_conn = {
    reader : in_channel;
    writer : out_channel;
    funcs : (string, (string -> string)) Hashtbl.t
  }

type gearman_res = {
    cmd : int;
    data : string;
  }

val connect : string -> int -> gearman_conn

val shutdown : gearman_conn -> unit

val echo : gearman_conn -> string -> string

val register : gearman_conn -> string -> (string -> string) -> unit

val do_work : gearman_conn -> unit

