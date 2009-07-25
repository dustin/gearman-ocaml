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
  }

type gearman_res = {
    cmd : int;
    data : string;
  }

val connect : string -> int -> gearman_conn

val shutdown : gearman_conn -> unit

val echo : gearman_conn -> string -> string
