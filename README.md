# ft_turing

An elegant, purely functional single-tape Turing Machine simulator written in OCaml. This project simulates a Turing Machine based on a JSON configuration file and evaluates its execution, including time and space complexity analysis (Bonus Part).

---

## Features

- **Purely Functional:** Built using the functional paradigm in OCaml. No side effects, no mutable states, and no imperative loops.
- **Infinite Tape:** Implemented using the **Zipper** data structure, allowing $O(1)$ head movement and tape expansion in both directions.
- **Robust Validation:** Strictly validates both the JSON machine description and the input string before execution. The simulator is guaranteed never to crash.
- **Interactive Visualization:** Displays the state of the tape, the head position, and the transition being executed at each step.
- **Bonus Part Included:** Calculates and displays **Time Complexity** (total steps) and **Space Complexity** (total unique tape cells used).

---

## Prerequisites

To compile and run this project, you need **OPAM** (OCaml Package Manager) installed on your system.

### Installing OPAM (if not installed)

- **macOS (via Homebrew):**bash
  brew install opam
  ```
- **Linux (Debian/Ubuntu):**
  ```bash
  sudo apt-get install opam
  ```

Initialize OPAM:
```bash
opam init
eval $(opam env)
```

---

## Compilation

The project uses a smart `Makefile` that automatically detects and installs all required dependencies (`dune` and `yojson`) via OPAM.

To compile the project, simply run:
```bash
make
```

This will produce a beautiful ASCII-art confirmation and create the executable `./ft_turing` in the root directory.

### Other Makefile Commands

- `make clean` - Removes temporary build files.
- `make fclean` - Removes build files and the executable.
- `make re` - Recompiles the project from scratch.

---

## Usage

```bash
./ft_turing [-h] jsonfile input
```

### Arguments:
- `jsonfile`: Path to the JSON file containing the machine description.
- `input`: The initial string to be written on the tape.
- `-h, --help`: Show the help message and exit.

---

## The 5 Included Machines

The `machines/` directory contains 5 pre-configured Turing Machines:

1. **Unary Addition** (`machines/unary_add.json`): Computes the sum of two unary numbers separated by `+`. (e.g., `111+11` becomes `11111`).
2. **Palindrome Detector** (`machines/palindrome.json`): Decides if the input string is a palindrome. Writes `y` or `n` at the end of the tape.
3. **$0^n1^n$ Language** (`machines/0n1n.json`): Decides if the input consists of $n$ zeros followed by exactly $n$ ones. Writes `y` or `n` at the end.
4. **$0^{2^n}$ Language** (`machines/02n.json`): Decides if the length of the input of zeros is a power of 2. Writes `y` or `n` at the end.
5. **Universal Turing Machine** (`machines/utm.json`): A conceptual machine designed to simulate the Unary Addition machine.

---

## Test Suite (How to Run)

Here is a comprehensive list of test cases you can run to verify the simulator and the machines.

### 1. Unary Addition
Computes $3 + 2 = 5$.
```bash
./ft_turing machines/unary_add.json "111+11"
```
*Expected Output:* The tape ends with `11111` under the head, followed by the complexity report.

### 2. Palindrome Detector
- **Valid Palindrome:**
  ```bash
  ./ft_turing machines/palindrome.json "abbba"
  ```
  *Expected Output:* Tape ends with `abbbay` (accepted).
  
- **Invalid Palindrome:**
  ```bash
  ./ft_turing machines/palindrome.json "abbab"
  ```
  *Expected Output:* Tape ends with `abbabn` (rejected).

### 3. $0^n1^n$ Language
- **Valid String ($0^3 1^3$):**
  ```bash
  ./ft_turing machines/0n1n.json "000111"
  ```
  *Expected Output:* Tape ends with `000111y` (accepted).

- **Invalid String (unbalanced):**
  ```bash
  ./ft_turing machines/0n1n.json "00011"
  ```
  *Expected Output:* Tape ends with `00011n` (rejected).

### 4. $0^{2^n}$ Language
- **Valid String (length 4 = $2^2$):**
  ```bash
  ./ft_turing machines/02n.json "0000"
  ```
  *Expected Output:* Tape ends with `0000y` (accepted).

- **Invalid String (length 3 $\neq 2^n$):**
  ```bash
  ./ft_turing machines/02n.json "000"
  ```
  *Expected Output:* Tape ends with `000n` (rejected).

### 5. Error Handling Tests (Guaranteed No Crashes)
- **Invalid JSON file:**
  ```bash
  ./ft_turing machines/unary_add.json "111+11invalid_char"
  ```
  *Expected Output:* Clean error message explaining that the input contains characters not present in the machine's alphabet.

- **Missing file:**
  ```bash
  ./ft_turing non_existent.json "111"
  ```
  *Expected Output:* Clean error message: `Error parsing machine: File system error...`
```

