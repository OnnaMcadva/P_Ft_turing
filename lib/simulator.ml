open Machine

(* Structure to hold simulation statistics for the bonus part *)
type stats = {
  steps : int;
  space : int;
}

(* Helper to print the beautiful header of the machine configuration *)
let print_header (m : Machine.t) =
  let print_line () = print_endline (String.make 80 '*') in
  print_line ();
  Printf.printf "* %-76s *\n" m.name;
  print_line ();

  (* Print Alphabet *)
  let alphabet_str = String.concat ", " (List.map (String.make 1) m.alphabet) in
  Printf.printf "Alphabet: [ %s ]\n" alphabet_str;

  (* Print States *)
  let states_str = String.concat ", " m.states in
  Printf.printf "States  : [ %s ]\n" states_str;

  (* Print Initial & Finals *)
  Printf.printf "Initial : %s\n" m.initial;
  let finals_str = String.concat ", " m.finals in
  Printf.printf "Finals  : [ %s ]\n" finals_str;

  (* Print Transitions *)
  StateMap.iter (fun state trans_list ->
    List.iter (fun t ->
      Printf.printf "(%s, %c) -> (%s, %c, %s)\n"
        state t.read t.to_state t.write (string_of_action t.action)
    ) trans_list
  ) m.transitions;
  print_line ()

(* Helper to find a transition for a given state and character *)
let find_transition (m : Machine.t) (state : string) (read_char : char) : Machine.transition option =
  match StateMap.find_opt state m.transitions with
  | None -> None
  | Some trans_list ->
      List.find_opt (fun t -> t.read = read_char) trans_list

(* The main simulation loop using recursion (pure functional style) *)
let simulate (m : Machine.t) (initial_input : string) : (stats, string) result =
  print_header m;

  let init_tape = Tape.make initial_input m.blank in

  (* Recursive execution function *)
  let rec step (state : string) (tape : Tape.t) (steps_count : int) (curr_pos : int) (min_pos : int) (max_pos : int) =
    let current_char = Tape.read tape in

    (* Check if we have reached a final state *)
    if List.mem state m.finals then
      Ok { steps = steps_count; space = (max_pos - min_pos + 1) }
    else
      match find_transition m state current_char with
      | None ->
          Error (Printf.sprintf "Machine blocked in state '%s' reading character '%c'." state current_char)
      | Some t ->
          (* Print current tape state and the transition we are about to make *)
          let tape_str = Tape.to_string tape in
          let action_str = string_of_action t.action in
          Printf.printf "%s (%s, %c) -> (%s, %c, %s)\n"
            tape_str state current_char t.to_state t.write action_str;

          (* Apply transition (creates a new tape) *)
          let written_tape = Tape.write tape t.write in

          (* Move head and calculate new position *)
          let (new_tape, next_pos) =
            match t.action with
            | Left -> (Tape.move_left written_tape, curr_pos - 1)
            | Right -> (Tape.move_right written_tape, curr_pos + 1)
          in

          (* Recurse with updated metrics *)
          step t.to_state new_tape (steps_count + 1) next_pos (min min_pos next_pos) (max max_pos next_pos)
  in

  (* Start simulation at position 0 *)
  step m.initial init_tape 0 0 0 0