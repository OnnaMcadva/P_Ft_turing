(* https://ocaml.org/play *)

(* 1. МОДУЛЬ ЛЕНТЫ (Tape) *)
module Tape = struct
  type t = {
    left : char list;
    current : char;
    right : char list;
    blank : char;
  }

  let make (input : string) (blank : char) : t =
    if String.length input = 0 then
      { left = []; current = blank; right = []; blank }
    else
      let chars = List.init (String.length input) (String.get input) in
      match chars with
      | [] -> { left = []; current = blank; right = []; blank }
      | hd :: tl -> { left = []; current = hd; right = tl; blank }

  let read (tape : t) : char = tape.current

  let write (tape : t) (c : char) : t = { tape with current = c }

  let move_left (tape : t) : t =
    match tape.left with
    | [] -> { left = []; current = tape.blank; right = tape.current :: tape.right; blank = tape.blank }
    | hd :: tl -> { left = tl; current = hd; right = tape.current :: tape.right; blank = tape.blank }

  let move_right (tape : t) : t =
    match tape.right with
    | [] -> { left = tape.current :: tape.left; current = tape.blank; right = []; blank = tape.blank }
    | hd :: tl -> { left = tape.current :: tape.left; current = hd; right = tl; blank = tape.blank }

  let to_string (tape : t) : string =
    let string_of_char_list l = String.concat "" (List.map (String.make 1) l) in
    let left_str = string_of_char_list (List.rev tape.left) in
    let current_str = Printf.sprintf "<%c>" tape.current in
    let right_str = string_of_char_list tape.right in
    "[" ^ left_str ^ current_str ^ right_str ^ "]"
end

(* 2. ТИПЫ ДАННЫХ МАШИНЫ *)
type action = Left | Right

type transition = {
  read : char;
  to_state : string;
  write : char;
  action : action;
}

module StateMap = Map.Make(String)

type machine = {
  name : string;
  blank : char;
  initial : string;
  finals : string list;
  transitions : (transition list) StateMap.t;
}

(* 3. СИМУЛЯТОР *)
let simulate (m : machine) (initial_input : string) : unit =
  let rec step (state : string) (tape : Tape.t) (steps_count : int) =
    let current_char = Tape.read tape in
    
    if List.mem state m.finals then
      begin
        print_endline (String.make 60 '=');
        Printf.printf "SUCCESS! Machine halted in state '%s'\n" state;
        Printf.printf "Total steps: %d\n" steps_count;
        Printf.printf "Final tape state: %s\n" (Tape.to_string tape);
        print_endline (String.make 60 '=')
      end
    else
      match StateMap.find_opt state m.transitions with
      | None -> Printf.printf "ERROR: No transitions for state %s\n" state
      | Some trans_list ->
          match List.find_opt (fun t -> t.read = current_char) trans_list with
          | None -> Printf.printf "ERROR: Blocked in state %s reading %c\n" state current_char
          | Some t ->
              let action_str = match t.action with Left -> "LEFT" | Right -> "RIGHT" in
              (* Выводим текущее состояние ленты и переход *)
              Printf.printf "%-30s (%s, %c) -> (%s, %c, %s)\n"
                (Tape.to_string tape) state current_char t.to_state t.write action_str;
              
              let written_tape = Tape.write tape t.write in
              let next_tape =
                match t.action with
                | Left -> Tape.move_left written_tape
                | Right -> Tape.move_right written_tape
              in
              step t.to_state next_tape (steps_count + 1)
  in
  Printf.printf "Simulating: %s\n" m.name;
  Printf.printf "Input: %s\n" initial_input;
  print_endline (String.make 60 '-');
  let init_tape = Tape.make initial_input m.blank in
  step m.initial init_tape 0

(* 4. ОПИСАНИЕ МАШИНЫ УНАРНОГО СЛОЖЕНИЯ (unary_add) *)
let unary_add_transitions =
  StateMap.empty
  |> StateMap.add "find_plus" [
       { read = '1'; to_state = "find_plus"; write = '1'; action = Right };
       { read = '+'; to_state = "find_end";  write = '1'; action = Right };
     ]
  |> StateMap.add "find_end" [
       { read = '1'; to_state = "find_end";  write = '1'; action = Right };
       { read = '.'; to_state = "erase_last"; write = '.'; action = Left };
     ]
  |> StateMap.add "erase_last" [
       { read = '1'; to_state = "HALT";      write = '.'; action = Left };
     ]

let my_machine = {
  name = "unary_add";
  blank = '.';
  initial = "find_plus";
  finals = ["HALT"];
  transitions = unary_add_transitions;
}

(* 5. ТОЧКА ВХОДА: Запуск сложения 3 + 2 (111 + 11) *)
let () =
  simulate my_machine "111+11"
