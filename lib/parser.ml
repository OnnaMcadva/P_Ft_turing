(* lib/parser.ml *)

open Yojson.Basic.Util

(* Define the monadic bind operator for Result type to handle errors cleanly *)
let ( let* ) = Result.bind

(* Helper to convert a JSON string of length 1 to a char *)
let to_char_res (json : Yojson.Basic.t) (field_name : string) : (char, string) result =
  try
    let s = to_string json in
    if String.length s = 1 then
      Ok (String.get s 0)
    else
      Error (Printf.sprintf "Invalid length for field '%s': expected 1 char, got '%s'" field_name s)
  with _ ->
    Error (Printf.sprintf "Field '%s' is not a valid string" field_name)

(* Helper to convert a JSON list of strings to a list of chars *)
let to_char_list_res (json : Yojson.Basic.t) (field_name : string) : (char list, string) result =
  try
    let list_of_json = to_list json in
    let rec convert acc = function
      | [] -> Ok (List.rev acc)
      | hd :: tl ->
          match to_char_res hd field_name with
          | Ok c -> convert (c :: acc) tl
          | Error _ as err -> err
    in
    convert [] list_of_json
  with _ ->
    Error (Printf.sprintf "Field '%s' is not a valid list of strings" field_name)

(* Helper to convert a JSON list of strings to a OCaml list of strings *)
let to_string_list_res (json : Yojson.Basic.t) (field_name : string) : (string list, string) result =
  try
    Ok (List.map to_string (to_list json))
  with _ ->
    Error (Printf.sprintf "Field '%s' is not a valid list of strings" field_name)

(* Parse a single transition object *)
let parse_transition (json : Yojson.Basic.t) : (Machine.transition, string) result =
  try
    let* read = to_char_res (member "read" json) "read" in
    let to_state = to_string (member "to_state" json) in
    let* write = to_char_res (member "write" json) "write" in
    let action_str = to_string (member "action" json) in
    let* action = Machine.action_of_string action_str in
    Ok { Machine.read; to_state; write; action }
  with
  | Type_error (msg, _) -> Error ("Transition parsing type error: " ^ msg)
  | Failure msg -> Error ("Transition parsing failure: " ^ msg)
  | _ -> Error "Invalid transition format"

(* Parse the transitions dictionary *)
let parse_transitions (json : Yojson.Basic.t) : (Machine.transitions_map, string) result =
  try
    let assoc_list = to_assoc json in
    let rec parse_assoc acc = function
      | [] -> Ok acc
      | (state, trans_list_json) :: tl ->
          let trans_json_list = to_list trans_list_json in
          let rec parse_list acc_trans = function
            | [] -> Ok (List.rev acc_trans)
            | hd :: tl_t ->
                let* t = parse_transition hd in
                parse_list (t :: acc_trans) tl_t
          in
          let* parsed_trans = parse_list [] trans_json_list in
          parse_assoc (Machine.StateMap.add state parsed_trans acc) tl
    in
    parse_assoc Machine.StateMap.empty assoc_list
  with
  | Type_error (msg, _) -> Error ("Transitions map type error: " ^ msg)
  | _ -> Error "Invalid transitions structure"

(* Main entry point: parse a JSON file and return a Machine.t *)
let parse_file (filename : string) : (Machine.t, string) result =
  try
    let json = Yojson.Basic.from_file filename in
    
    let name = to_string (member "name" json) in
    let* alphabet = to_char_list_res (member "alphabet" json) "alphabet" in
    let* blank = to_char_res (member "blank" json) "blank" in
    let* states = to_string_list_res (member "states" json) "states" in
    let initial = to_string (member "initial" json) in
    let* finals = to_string_list_res (member "finals" json) "finals" in
    let* transitions = parse_transitions (member "transitions" json) in
    
    let machine = {
      Machine.name;
      alphabet;
      blank;
      states;
      initial;
      finals;
      transitions;
    } in
    
    (* Validate the machine structure using our validation logic from Step 4 *)
    let* () = Machine.validate machine in
    Ok machine
  with
  | Sys_error msg -> Error ("File system error: " ^ msg)
  | Yojson.Json_error msg -> Error ("JSON syntax error: " ^ msg)
  | Type_error (msg, _) -> Error ("JSON structure error: " ^ msg)
  | Failure msg -> Error ("Parsing failure: " ^ msg)
  | _ -> Error "Unknown error occurred while parsing the JSON file"
