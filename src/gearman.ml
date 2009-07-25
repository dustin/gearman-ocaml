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

let can_do = 1
let grab_job = 9
let no_job = 10
let job_assign = 11
let pre_sleep = 4
let noop = 6
let work_complete = 13

type gearman_conn = {
    reader : in_channel;
    writer : out_channel;
    funcs : (string, (string -> string)) Hashtbl.t
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
	{ reader = reader; writer = writer; funcs = Hashtbl.create 1 }

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

let register gm name f =
  Hashtbl.replace gm.funcs name f;
  send_cmd gm can_do name

let do_pre_sleep gm =
  send_cmd gm pre_sleep "";
  let res = recv_response gm in
  assert (res.cmd == noop);
  ()

let dispatch gm data =
  let null = Char.chr 0 in
  let null_str = String.make 1 null in
  let first_null = String.index data null in
  let job_id = String.sub data 0 first_null in
  let second_null = String.index_from data (first_null + 1) null in
  let fname = String.sub data (first_null + 1) (second_null - first_null - 1) in
  let job_data = String.sub data (second_null + 1)
      ((String.length data) - second_null - 1) in
  let func_res = (Hashtbl.find gm.funcs fname) job_data in
  send_cmd gm work_complete (job_id ^ null_str ^ func_res)

let rec do_work gm =
  send_cmd gm grab_job "";
  let res = recv_response gm in
  match res.cmd with
    10 -> do_pre_sleep gm; do_work gm
  | 11 -> dispatch gm res.data
  | _  -> assert (false)

let rec work_forever gm =
  do_work gm;
  work_forever gm
