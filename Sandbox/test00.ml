(* https://ocaml.org/play *)

(* Функция подсчета длины списка *)
let rec count_length list =
  match list with
  | [] -> 0
  | hd :: tl -> 1 + count_length tl

(* Тестируем функцию *)
let my_list = [10; 20; 30; 40; 50]
let result1 = count_length my_list

(* Выводим результат на экран *)
let () = 
  Printf.printf "👽 The list has %d elements!\n" result1

let rec count_ones list =
  match list with
  | [] -> 0
  | hd :: tl -> 
      if hd = '1' then 
        1 + count_ones tl
      else 
        0 + count_ones tl

let my_tape = ['1'; '.'; '1'; '1'; '.'; '1']
let result2 = count_ones my_tape

let () = 
  Printf.printf "👽 Found %d ones on the tape!\n" result2
  
let rec count_flo list =
  match list with
  | [] -> 0
  | hd :: tl ->
      if hd = 0.5 then
        1 + count_flo tl
      else
        0 + count_flo tl

let my_flo = [0.1; 0.2; 0.5; 0.5; 0.57]
let result3 = count_flo my_flo

let () =
  Printf.printf "👽 The list has %d elements!\n" result3
