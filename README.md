# ft_turing

<img width="528" height="237" alt="изображение" src="https://github.com/user-attachments/assets/06d640e6-84fe-4e34-8b17-feda8598e9d3" />



An elegant, purely functional single-tape Turing Machine simulator written in OCaml. This project simulates a Turing Machine based on a JSON configuration file and evaluates its execution, featuring a built-in **Time and Space Complexity Analyzer (Bonus Part)**.

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

### Installing OPAM

#### For macOS (via Homebrew):bash
brew install opam
```

#### For Linux (Debian/Ubuntu):
```bash
sudo apt-get install opam
```

#### For 42 Cluster (Sudo-free installation):
If you are working on a 42 school computer without root privileges, install OPAM locally using the following commands:
```bash
curl -L https://github.com/ocaml/opam/releases/download/2.5.1/opam-2.5.1-x86_64-linux -o ~/.local/bin/opam
chmod +x ~/.local/bin/opam
~/.local/bin/opam --version
```

### Initializing OPAM & Dependencies

Initialize the OPAM environment:
```bash
opam init -y
eval $(opam env)
```

Install the required build system (`dune`) and JSON library (`yojson`):
```bash
opam install dune -y
eval $(opam env)

opam install yojson -y
eval $(opam env)
```

---

## Compilation

The project uses a smart `Makefile` that automatically detects and installs all required dependencies via OPAM.

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

## Bonus Part: Complexity Analysis

The **Bonus Part** (Time and Space complexity analysis) is fully implemented and integrated directly into the simulator. It executes automatically at the end of every successful simulation run.

### How it works:
1. **Time Complexity (Steps):** The simulator tracks the exact number of transitions executed from the initial state to the final state.
2. **Space Complexity (Memory):** The simulator tracks the head's position relative to the starting point (0). By recording the minimum and maximum coordinates visited by the head, it calculates the exact number of unique tape cells used: $\text{Space} = \text{Max Position} - \text{Min Position} + 1$.

---

## The 5 Included Machines

The `machines/` directory contains 5 pre-configured Turing Machines:

1. **Unary Addition** (`machines/unary_add.json`): Computes the sum of two unary numbers separated by `+`.
2. **Palindrome Detector** (`machines/palindrome.json`): Decides if the input string is a palindrome of '0's and '1's. Writes `y` or `n` at the end of the tape.
3. **$0^n1^n$ Language** (`machines/0n1n.json`): Decides if the input consists of $n$ zeros followed by exactly $n$ ones. Writes `y` or `n` at the end.
4. **$0^{2^n}$ Language** (`machines/02n.json`): Decides if the length of the input of zeros is a power of 2. Writes `y` or `n` at the end.
5. **Universal Turing Machine** (`machines/utm.json`): A mathematically rigorous machine designed to simulate the Unary Addition machine by reading its transition table directly from the tape.

---

## Manual Test Cases

Use these short manual checks to verify the simulator and each machine during evaluation.

### 1. Unary Addition (`unary_add.json`)
Computes $A + B = C$ in unary representation.

* **Test 1.1: Standard addition ($3 + 2 = 5$)**
```bash
./ft_turing machines/unary_add.json "111+11="
```
*Expected Result:* Tape ends with `11111` under the head.

* **Test 1.2: Minimal addition ($1 + 1 = 2$)**
```bash
./ft_turing machines/unary_add.json "1+1="
```
*Expected Result:* Tape ends with `11` under the head.

* **Test 1.3: No plus sign (blocked)**
```bash
./ft_turing machines/unary_add.json "111"
```
*Expected Result:* The machine halts cleanly as blocked.

* **Test 1.4: Larger addition ($10 + 10 = 20$)**
```bash
./ft_turing machines/unary_add.json "1111111111+1111111111="
```
*Expected Result:* Tape ends with 20 ones.

---

### 2. Palindrome Detector (`palindrome.json`)
Checks if the input string reads the same backwards as forwards. Writes `y` (yes) or `n` (no) at the end.

* **Test 2.1: Single-character palindrome (accepted)**
```bash
./ft_turing machines/palindrome.json "0"
```
*Expected Result:* Tape ends with `y` (Accepted).

* **Test 2.2: Odd-length palindrome (accepted)**
```bash
./ft_turing machines/palindrome.json "10"
```
*Expected Result:* Tape ends with `n` (Accepted).

* **Test 2.3: Even-length palindrome (accepted)**
```bash
./ft_turing machines/palindrome.json "0110"
```
*Expected Result:* Tape ends with `y` (Accepted).

* **Test 2.4: Invalid character (validation error)**
```bash
./ft_turing machines/palindrome.json "102"
```
*Expected Result:* Fails input validation immediately because 'c' is not in the machine's alphabet.
*Output:* `Error validating input: Input error: character '2' is not in the alphabet.`

---

### 3. $0^n1^n$ Language (`0n1n.json`)
Checks if the input consists of $n$ zeros followed by exactly $n$ ones. Writes `y` or `n` at the end.

* **Test 3.1: Balanced string ($0^3 1^3$ - accepted)**
```bash
./ft_turing machines/0n1n.json "000111"
```
*Expected Result:* Tape ends with `y` (Accepted).

* **Test 3.2: Too many zeros (rejected)**
```bash
./ft_turing machines/0n1n.json "000011"
```
*Expected Result:* Tape ends with `n` (Rejected).

* **Test 3.3: Too many ones (rejected)**
```bash
./ft_turing machines/0n1n.json "00111"
```
*Expected Result:* Tape ends with `n` (Rejected).

* **Test 3.4: Wrong order (rejected)**
```bash
./ft_turing machines/0n1n.json "111000"
```
*Expected Result:* Tape ends with `n` (Rejected).

---

### 4. $0^{2n}$ Language (`02n.json`)
Checks if the input contains an even number of zeros: $2, 4, 6, \dots$ (and, if you accept $n=0$, the empty string). Writes `y` or `n` at the end.

* **Test 4.1: Length 2 (accepted)**
```bash
./ft_turing machines/02n.json "00"
```
*Expected Result:* Tape ends with `y` (Accepted).

* **Test 4.2: Length 4 (accepted)**
```bash
./ft_turing machines/02n.json "0000"
```
*Expected Result:* Tape ends with `y` (Accepted).

* **Test 4.3: Length 6 (accepted)**
```bash
./ft_turing machines/02n.json "000000"
```
*Expected Result:* Tape ends with `y` (Accepted).

* **Test 4.4: Odd length (Length 3 - rejected)**
```bash
./ft_turing machines/02n.json "000"
```
*Expected Result:* Tape ends with `n` (Rejected).

* **Test 4.5: Odd length (Length 5 - rejected)**
```bash
./ft_turing machines/02n.json "00000"
```
*Expected Result:* Tape ends with `n` (Rejected).

* **Test 4.6: Empty input (accepted if you treat $n=0$ as valid)**
```bash
./ft_turing machines/02n.json ""
```
*Expected Result:* Tape ends with `y` (Accepted).

---

### 5. Universal Turing Machine (`utm.json`)
The Universal Turing Machine (UTM) reads the transition table of `unary_add` directly from the tape, parses it, and executes it on the virtual input.

#### Tape encoding scheme:
The tape is divided into three sections using the `#` character:
`[Current State] # [Transition Rules] # [Virtual Tape with Head Marker '*']`

For `unary_add`, the characters are mapped as follows:
- `+` is encoded as `p`
- `.` (blank) is encoded as `d`

The rules are written as 5-character blocks: `[State][Read][Write][Direction][NextState]`.
Rules list: `A11RA;Ap1RB;B11RB;BddLC;C1dLH`

#### Running the UTM:
To simulate `unary_add` computing $3 + 2 = 5$ on the UTM, run:
```bash
./ft_turing machines/utm.json "A#A11RA;Ap1RB;B11RB;BddLC;C1dLH#111*p11d"
```
*Expected Result:* The UTM reads the rules from the tape, executes them step-by-step, and halts when the virtual state becomes `H`.

---

### 6. Robustness & error handling tests

* **Test 6.1: Missing JSON file**
```bash
./ft_turing machines/does_not_exist.json "111"
```
*Expected Result:* Clean exit with error: `Error parsing machine: File system error...`

* **Test 6.2: Blocked machine (no valid transition)**
```bash
./ft_turing machines/unary_add.json "111"
```
*Expected Result:* The machine starts, but halts cleanly when blocked: `Simulation halted: Machine blocked in state 'find_plus' reading character '.'.`

---

## License

No license is provided — use and modification for learning purposes only.
```
