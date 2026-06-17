(* Define the Tape type *)
type t = {
  left : char list;
  current : char;
  right : char list;
  blank : char;
}

(* Initialize the tape with an input string and a blank character.
   According to Turing Machine rules, the head starts at the first character of the input.
   If the input is empty, the tape contains only the blank character. *)
let make (input : string) (blank : char) : t =
  if String.length input = 0 then
    { left = []; current = blank; right = []; blank }
  else
    (* Convert string to a list of characters *)
    let chars = List.init (String.length input) (String.get input) in
    match chars with
    | [] -> { left = []; current = blank; right = []; blank }
    | hd :: tl -> { left = []; current = hd; right = tl; blank }

(* Read the character under the head *)
let read (tape : t) : char =
  tape.current

(* Write a character under the head (returns a NEW tape) *)
let write (tape : t) (c : char) : t =
  { tape with current = c }

(* Move the head to the LEFT (returns a NEW tape) *)
let move_left (tape : t) : t =
  match tape.left with
  | [] ->
      (* If there is nothing on the left, we generate a blank character *)
      { left = []; current = tape.blank; right = tape.current :: tape.right; blank = tape.blank }
  | hd :: tl ->
      (* Move head left: take the first element from 'left' as new 'current' *)
      { left = tl; current = hd; right = tape.current :: tape.right; blank = tape.blank }

(* Move the head to the RIGHT (returns a NEW tape) *)
let move_right (tape : t) : t =
  match tape.right with
  | [] ->
      (* If there is nothing on the right, we generate a blank character *)
      { left = tape.current :: tape.left; current = tape.blank; right = []; blank = tape.blank }
  | hd :: tl ->
      (* Move head right: take the first element from 'right' as new 'current' *)
      { left = tape.current :: tape.left; current = hd; right = tl; blank = tape.blank }

(* Convert the tape to a string representation for visualization.
   Example output format: [111<->11=.............]
   We will show some blank characters on the edges to simulate infinity. *)
let to_string (tape : t) : string =
  (* Helper to convert char list to string *)
  let string_of_char_list l = String.concat "" (List.map (String.make 1) l) in
  
  (* We reverse 'left' because it is stored backwards *)
  let left_str = string_of_char_list (List.rev tape.left) in
  let current_str = Printf.sprintf "<%c>" tape.current in
  let right_str = string_of_char_list tape.right in
  
  (* Add some trailing blanks to show infinity (e.g., 10 blanks) *)
  let infinite_blanks = String.make 12 tape.blank in
  
  "[" ^ left_str ^ current_str ^ right_str ^ infinite_blanks ^ "]"
