open Ft_turing_lib

(* Print the usage help message *)
let print_usage () =
  print_endline "usage: ft_turing [-h] jsonfile input";
  print_endline "";
  print_endline "positional arguments:";
  print_endline "  jsonfile    json description of the machine";
  print_endline "  input       input of the machine";
  print_endline "";
  print_endline "optional arguments:";
  print_endline "  -h, --help  show this help message and exit"

(* Print the bonus complexity statistics *)
let print_stats (stats : Simulator.stats) =
  let print_line () = print_endline (String.make 80 '=') in
  print_line ();
  Printf.printf "  %sALGORITHM COMPLEXITY (BONUS)%s\n" "\x1b[1;33m" "\x1b[0m";
  print_line ();
  Printf.printf "  Time Complexity (Steps executed) : %s%d%s\n" "\x1b[1;32m" stats.steps "\x1b[0m";
  Printf.printf "  Space Complexity (Tape cells used): %s%d%s\n" "\x1b[1;32m" stats.space "\x1b[0m";
  print_line ()

(* Main execution flow *)
let main () =
  let args = Sys.argv in
  let argc = Array.length args in
  
  if argc = 2 && (args.(1) = "-h" || args.(1) = "--help") then
    begin
      print_usage ();
      exit 0
    end
  else if argc <> 3 then
    begin
      Printf.eprintf "%sError: Invalid number of arguments.%s\n\n" "\x1b[1;31m" "\x1b[0m";
      print_usage ();
      exit 1
    end
  else
    let jsonfile = args.(1) in
    let input = args.(2) in
    
    (* 1. Parse the JSON file *)
    match Parser.parse_file jsonfile with
    | Error err_msg ->
        Printf.eprintf "%sError parsing machine:%s %s\n" "\x1b[1;31m" "\x1b[0m" err_msg;
        exit 1
    | Ok machine ->
        (* 2. Validate the input string against the machine's alphabet *)
        match Machine.validate_input machine input with
        | Error err_msg ->
            Printf.eprintf "%sError validating input:%s %s\n" "\x1b[1;31m" "\x1b[0m" err_msg;
            exit 1
        | Ok () ->
            (* 3. Run the simulation *)
            match Simulator.simulate machine input with
            | Error err_msg ->
                Printf.eprintf "\n%sSimulation halted:%s %s\n" "\x1b[1;31m" "\x1b[0m" err_msg;
                exit 1
            | Ok stats ->
                print_endline "";
                print_stats stats;
                exit 0

(* Safe entry point wrapper to prevent any unexpected crashes *)
let () =
  try
    main ()
  with
  | exn ->
      Printf.eprintf "%sFatal unexpected error:%s %s\n" "\x1b[1;31m" "\x1b[0m" (Printexc.to_string exn);
      exit 1
