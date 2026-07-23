(* Define the Tape type *)
type t = {
  left : char list;
  current : char;
  right : char list;
  blank : char;
}

(* Initialize the tape with an input string and a blank character *)
let make (input : string) (blank : char) : t =
  if String.length input = 0 then
    { left = []; current = blank; right = []; blank }
  else
    let chars = List.init (String.length input) (String.get input) in
    match chars with
    | [] -> { left = []; current = blank; right = []; blank }
    | hd :: tl -> { left = []; current = hd; right = tl; blank }

(* Read the character under the head *)
let read (tape : t) : char =
  tape.current

(* Write a character under the head *)
let write (tape : t) (c : char) : t =
  { tape with current = c }

(* Move the head to the LEFT *)
let move_left (tape : t) : t =
  match tape.left with
  | [] ->
      { left = []; current = tape.blank; right = tape.current :: tape.right; blank = tape.blank }
  | hd :: tl ->
      { left = tl; current = hd; right = tape.current :: tape.right; blank = tape.blank }

(* Move the head to the RIGHT *)
let move_right (tape : t) : t =
  match tape.right with
  | [] ->
      { left = tape.current :: tape.left; current = tape.blank; right = []; blank = tape.blank }
  | hd :: tl ->
      { left = tape.current :: tape.left; current = hd; right = tl; blank = tape.blank }

(* Convert the tape to a string representation with a fixed 20-character window *)
let to_string (tape : t) : string =
  let left_part = List.rev tape.left in
  let h_index = List.length left_part in
  let full_tape = left_part @ [tape.current] @ tape.right in

  let start_idx = if h_index < 15 then 0 else h_index - 15 in
  let needed_len = start_idx + 20 in

  let rec pad list len =
    if List.length list >= len then list
    else pad (list @ [tape.blank]) len
  in
  let padded_tape = pad full_tape (max 40 needed_len) in

  let rec sublist list start count =
    match list with
    | [] -> []
    | hd :: tl ->
        if start > 0 then sublist tl (start - 1) count
        else if count > 0 then hd :: sublist tl 0 (count - 1)
        else []
  in
  let window = sublist padded_tape start_idx 20 in

  let head_idx_in_window = h_index - start_idx in
  let rec format_window idx = function
    | [] -> ""
    | hd :: tl ->
        let s =
          if idx = head_idx_in_window then Printf.sprintf "<%c>" hd
          else String.make 1 hd
        in
        s ^ format_window (idx + 1) tl
  in
  "[" ^ format_window 0 window ^ "]"
