(* https://ocaml.org/play *)

(* Функция подсчета длины списка *)
let rec count_length list =
  match list with
  | [] -> 0
  | hd :: tl -> 1 + count_length tl

(* Тестируем функцию *)
let my_list = [10; 20; 30; 40; 50]
let result = count_length my_list

(* Выводим результат на экран *)
let () = 
  Printf.printf "The list has %d elements!\n" result
