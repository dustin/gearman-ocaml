(*
 * Copyright (c) 2009  Dustin Sallings <dustin@spy.net>
 *)

open Unix

(* "\0RES" *)
let res_magic = 5391699
(* "\0REQ" *)
let req_magic = 5391697

let echo_req = 16
let echo_res = 17

type gearman_conn = {
    reader : in_channel;
    writer : out_channel;
  }

type gearman_res = {
    cmd : int;
    data : string;
  }

let connect hostname port =
	let addr = ADDR_INET ((gethostbyname hostname).h_addr_list.(0), port) in
	let stuff = open_connection addr in
    let reader = fst stuff in
    let writer = snd stuff in
    set_binary_mode_in reader true;
    set_binary_mode_out writer true;
	{ reader = reader; writer = writer }

let shutdown gm =
  shutdown_connection gm.reader

let send_cmd gm cmd data =
  output_binary_int gm.writer req_magic;
  output_binary_int gm.writer cmd;
  output_binary_int gm.writer (String.length data);
  output_string gm.writer data;
  flush gm.writer

let recv_response gm =
  let magic = input_binary_int gm.reader in
  assert (magic = res_magic);
  let cmd = input_binary_int gm.reader in
  let len = input_binary_int gm.reader in
  let buf = String.create len in
  really_input gm.reader buf 0 len;
  { cmd = cmd; data = buf }

let echo gm data =
  send_cmd gm echo_req data;
  let res = recv_response gm in
  assert (res.cmd == echo_res);
  res.data
