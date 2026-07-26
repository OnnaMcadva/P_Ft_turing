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

## The 7 Included Machines

The `machines/` directory contains 7 pre-configured Turing Machines:

1. **Unary Addition** (`machines/unary_add.json`): Computes the sum of two unary numbers separated by `+`. Uses states: `scanright1`, `scanright2`, `eraselast`, `HALT`.

2. **Unary Subtraction** (`machines/unary_sub.json`): Computes the difference of two unary numbers separated by `-`. Uses states: `scanright`, `eraseone`, `subone`, `skip`, `HALT`.

3. **Palindrome Detector (0/1)** (`machines/palindrome.json`): Decides if the input string (of '0's and '1's) is a palindrome. Writes `y` or `n` at the end of the tape.

4. **Palindrome Detector (a/b)** (`machines/palindrome_x.json`): Decides if the input string (of 'a's and 'b's) is a palindrome. Writes `y` or `n` at the end of the tape.

5. **$0^n1^n$ Language** (`machines/0n1n.json`): Decides if the input consists of $n$ zeros followed by exactly $n$ ones. Writes `y` or `n` at the end.

6. **$0^{2n}$ Language** (`machines/02n.json`): Decides if the input contains an even number of zeros. Writes `y` or `n` at the end.

7. **Universal Turing Machine** (`machines/utm_unary_add.json`): A specialized UTM designed to simulate the Unary Addition machine by reading its transition table directly from the tape.

---

## Manual Test Cases

### 1. Unary Addition (`unary_add.json`)

* **Test 1.1: 3 + 2 = 5**
```bash
./ft_turing machines/unary_add.json "111+11="
```
*Expected:* Tape ends with `11111`.

* **Test 1.2: 1 + 1 = 2**
```bash
./ft_turing machines/unary_add.json "1+1="
```
*Expected:* Tape ends with `11`.

* **Test 1.3: 0 + 5 = 5**
```bash
./ft_turing machines/unary_add.json "+11111="
```
*Expected:* Tape ends with `11111`.

* **Test 1.4: 10 + 10 = 20**
```bash
./ft_turing machines/unary_add.json "1111111111+1111111111="
```
*Expected:* Tape ends with 20 ones.

* **Test 1.5: No plus sign (blocked)**
```bash
./ft_turing machines/unary_add.json "111"
```
*Expected:* `Simulation halted: Machine blocked in state 'scanright1' reading character '.'.`

---

### 2. Unary Subtraction (`unary_sub.json`)

* **Test 2.1: 5 - 2 = 3**
```bash
./ft_turing machines/unary_sub.json "11111-11="
```
*Expected:* Tape ends with `111`.

* **Test 2.2: 2 - 1 = 1**
```bash
./ft_turing machines/unary_sub.json "11-1="
```
*Expected:* Tape ends with `1`.

* **Test 2.3: 3 - 3 = 0**
```bash
./ft_turing machines/unary_sub.json "111-111="
```
*Expected:* Tape ends with `.` (blank).

* **Test 2.4: No minus sign (blocked)**
```bash
./ft_turing machines/unary_sub.json "11111"
```
*Expected:* `Simulation halted: Machine blocked in state 'scanright' reading character '.'.`

---

### 3. Palindrome Detector (0/1) (`palindrome.json`)

* **Test 3.1: Single char - accepted**
```bash
./ft_turing machines/palindrome.json "0"
```
*Expected:* Tape ends with `y`.

* **Test 3.2: "101" - accepted**
```bash
./ft_turing machines/palindrome.json "101"
```
*Expected:* Tape ends with `y`.

* **Test 3.3: "0110" - accepted**
```bash
./ft_turing machines/palindrome.json "0110"
```
*Expected:* Tape ends with `y`.

* **Test 3.4: "10" - rejected**
```bash
./ft_turing machines/palindrome.json "10"
```
*Expected:* Tape ends with `n`.

* **Test 3.5: Invalid character**
```bash
./ft_turing machines/palindrome.json "102"
```
*Expected:* `Error validating input: Input error: character '2' is not in the alphabet.`

---

### 4. Palindrome Detector (a/b) (`palindrome_x.json`)

* **Test 4.1: Single char - accepted**
```bash
./ft_turing machines/palindrome_x.json "a"
```
*Expected:* Tape ends with `y`.

* **Test 4.2: "aba" - accepted**
```bash
./ft_turing machines/palindrome_x.json "aba"
```
*Expected:* Tape ends with `y`.

* **Test 4.3: "abba" - accepted**
```bash
./ft_turing machines/palindrome_x.json "abba"
```
*Expected:* Tape ends with `y`.

* **Test 4.4: "ab" - rejected**
```bash
./ft_turing machines/palindrome_x.json "ab"
```
*Expected:* Tape ends with `n`.

* **Test 4.5: Invalid character**
```bash
./ft_turing machines/palindrome_x.json "abc"
```
*Expected:* `Error validating input: Input error: character 'c' is not in the alphabet.`

---

### 5. $0^n1^n$ Language (`0n1n.json`)

* **Test 5.1: "000111" - accepted ($n=3$)**
```bash
./ft_turing machines/0n1n.json "000111"
```
*Expected:* Tape ends with `y`.

* **Test 5.2: "000011" - rejected (too many 0s)**
```bash
./ft_turing machines/0n1n.json "000011"
```
*Expected:* Tape ends with `n`.

* **Test 5.3: "00111" - rejected (too many 1s)**
```bash
./ft_turing machines/0n1n.json "00111"
```
*Expected:* Tape ends with `n`.

* **Test 5.4: "111000" - rejected (wrong order)**
```bash
./ft_turing machines/0n1n.json "111000"
```
*Expected:* Tape ends with `n`.

* **Test 5.5: Empty string - accepted ($n=0$)**
```bash
./ft_turing machines/0n1n.json ""
```
*Expected:* Tape ends with `y`.

---

### 6. $0^{2n}$ Language (`02n.json`)

* **Test 6.1: "00" - accepted ($n=1$)**
```bash
./ft_turing machines/02n.json "00"
```
*Expected:* Tape ends with `y`.

* **Test 6.2: "0000" - accepted ($n=2$)**
```bash
./ft_turing machines/02n.json "0000"
```
*Expected:* Tape ends with `y`.

* **Test 6.3: "000000" - accepted ($n=3$)**
```bash
./ft_turing machines/02n.json "000000"
```
*Expected:* Tape ends with `y`.

* **Test 6.4: "000" - rejected (odd length)**
```bash
./ft_turing machines/02n.json "000"
```
*Expected:* Tape ends with `n`.

* **Test 6.5: "00000" - rejected (odd length)**
```bash
./ft_turing machines/02n.json "00000"
```
*Expected:* Tape ends with `n`.

* **Test 6.6: Empty string - accepted ($n=0$)**
```bash
./ft_turing machines/02n.json ""
```
*Expected:* Tape ends with `y`.

---

### 7. Universal Turing Machine (`utm_unary_add.json`)

The machine accepts an encoded unary addition machine followed by the input tape.

**Encoding:**

```
<Initial State><Encoded Machine>#<Input Tape>
```

where

- `A` = `scanright1`
- `B` = `scanright2`
- `C` = `eraselast`
- `H` = `HALT`

Example encoded machine:

```
A111A111R;A+B11R;B111B111R;B=CbL;C111HbR;
```

---

#### Test 7.1 — 3 + 2

```bash
./ft_turing machines/utm_unary_add.json \
"A111A111R;A+B11R;B111B111R;B=CbL;C111HbR;#111+11="
```

Expected: tape ends with `11111`.

---

#### Test 7.2 — 1 + 1

```bash
./ft_turing machines/utm_unary_add.json \
"A111A111R;A+B11R;B111B111R;B=CbL;C111HbR;#1+1="
```

Expected: tape ends with `11`.

---

#### Test 7.3 — 0 + 5

```bash
./ft_turing machines/utm_unary_add.json \
"A111A111R;A+B11R;B111B111R;B=CbL;C111HbR;#+11111="
```

Expected: tape ends with `11111`.

---

#### Test 7.4 — 10 + 10

```bash
./ft_turing machines/utm_unary_add.json \
"A111A111R;A+B11R;B111B111R;B=CbL;C111HbR;#1111111111+1111111111="
```

Expected: tape ends with twenty `1` symbols.

---

#### Test 7.5 — Start from state B

```bash
./ft_turing machines/utm_unary_add.json \
"B111A111R;A+B11R;B111B111R;B=CbL;C111HbR;#111+11="
```

Expected: simulation starts from encoded state `B`.

---

#### Test 7.6 — Immediate halt

```bash
./ft_turing machines/utm_unary_add.json \
"H111A111R;A+B11R;B111B111R;B=CbL;C111HbR;#111+11="
```

Expected: machine halts immediately.

---

#### Test 7.7 — Invalid initial state

```bash
./ft_turing machines/utm_unary_add.json \
"Z111A111R;A+B11R;B111B111R;B=CbL;C111HbR;#111+11="
```

Expected:

```
Simulation halted: Machine blocked in state 'read_state' reading character 'Z'.
```

---

### 8. Robustness & error handling

* **Test 8.1: Missing JSON file**
```bash
./ft_turing machines/does_not_exist.json "111"
```
*Expected:* `Error parsing machine: File system error...`

* **Test 8.2: Empty input string**
```bash
./ft_turing machines/unary_add.json ""
```
*Expected:* `Error validating input: Input cannot be empty`.

---

## License

No license is provided — use and modification for learning purposes only.
```
