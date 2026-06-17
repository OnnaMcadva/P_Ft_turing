(* 1. Define the direction of the head movement *)
type action = Left | Right

(* 2. Define a single transition rule *)
type transition = {
  read : char;
  to_state : string;
  write : char;
  action : action;
}

(* We use OCaml's standard Map to store transitions indexed by state name (string) *)
module StateMap = Map.Make(String)

type transitions_map = (transition list) StateMap.t

(* 3. Define the Machine structure *)
type t = {
  name : string;
  alphabet : char list;
  blank : char;
  states : string list;
  initial : string;
  finals : string list;
  transitions : transitions_map;
}

(* Helper to convert string action to our type *)
let action_of_string = function
  | "LEFT" -> Ok Left
  | "RIGHT" -> Ok Right
  | s -> Error ("Invalid action: " ^ s)

let string_of_action = function
  | Left -> "LEFT"
  | Right -> "RIGHT"

(* --- Validation Logic --- *)

(* Helper to check if an element exists in a list *)
let contains x list = List.mem x list

(* Validate the machine configuration according to the rules *)
let validate (m : t) : (unit, string) result =
  (* Rule 1: Blank must be in the alphabet *)
  if not (contains m.blank m.alphabet) then
    Error "Validation error: blank character is not in the alphabet."
  
  (* Rule 2: Initial state must be in the states list *)
  else if not (contains m.initial m.states) then
    Error ("Validation error: initial state '" ^ m.initial ^ "' is not in the states list.")
  
  (* Rule 3: All final states must be in the states list *)
  else if not (List.for_all (fun f -> contains f m.states) m.finals) then
    Error "Validation error: one or more final states are not in the states list."
  
  (* Rule 4: Validate transitions *)
  else
    let validate_transition state t =
      if not (contains t.read m.alphabet) then
        Error (Printf.sprintf "Transition error in state '%s': read character '%c' is not in the alphabet." state t.read)
      else if not (contains t.write m.alphabet) then
        Error (Printf.sprintf "Transition error in state '%s': write character '%c' is not in the alphabet." state t.write)
      else if not (contains t.to_state m.states) then
        Error (Printf.sprintf "Transition error in state '%s': target state '%s' is not in the states list." state t.to_state)
      else
        Ok ()
    in
    
    (* Check all transitions in the map *)
    let check_all_transitions =
      StateMap.fold (fun state t_list acc ->
        match acc with
        | Error _ as err -> err
        | Ok () ->
            if not (contains state m.states) then
              Error ("Validation error: transitions defined for state '" ^ state ^ "' which is not in the states list.")
            else
              (* Check for duplicate read characters in the same state (determinism) *)
              let rec has_duplicates seen = function
                | [] -> false
                | t :: tl -> if contains t.read seen then true else has_duplicates (t.read :: seen) tl
              in
              if has_duplicates [] t_list then
                Error ("Validation error: duplicate transitions defined for state '" ^ state ^ "'.")
              else
                (* Validate each transition's fields *)
                List.fold_left (fun acc_t t ->
                  match acc_t with
                  | Error _ as err -> err
                  | Ok () -> validate_transition state t
                ) (Ok ()) t_list
      ) m.transitions (Ok ())
    in
    check_all_transitions

(* Validate the input string against the machine's alphabet *)
let validate_input (m : t) (input : string) : (unit, string) result =
  let len = String.length input in
  let rec check i =
    if i >= len then
      Ok ()
    else
      let c = String.get input i in
      if c = m.blank then
        Error (Printf.sprintf "Input error: input string contains the blank character '%c'." m.blank)
      else if not (contains c m.alphabet) then
        Error (Printf.sprintf "Input error: character '%c' is not in the alphabet." c)
      else
        check (i + 1)
  in
  check 0
