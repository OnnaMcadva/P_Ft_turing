# ft_turing

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

### Installing OPAM (if not installed)

- **macOS (via Homebrew):**
  ```bash
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

## Bonus Part: Complexity Analysis

The **Bonus Part** (Time and Space complexity analysis) is fully implemented and integrated directly into the simulator. You do not need any special flags to run it — **it executes automatically at the end of every successful simulation run.**

### How it works:
1. **Time Complexity (Steps):** The simulator tracks the exact number of transitions executed from the initial state to the final state.
2. **Space Complexity (Memory):** The simulator tracks the head's position relative to the starting point (0). By recording the minimum and maximum coordinates visited by the head, it calculates the exact number of unique tape cells used: $\text{Space} = \text{Max Position} - \text{Min Position} + 1$.

### Example Bonus Output:
```text
================================================================================
  ALGORITHM COMPLEXITY (BONUS)
================================================================================
  Time Complexity (Steps executed) : 18
  Space Complexity (Tape cells used): 8
================================================================================
```

---

## The 5 Included Machines

The `machines/` directory contains 5 pre-configured Turing Machines:

1. **Unary Addition** (`machines/unary_add.json`): Computes the sum of two unary numbers separated by `+`.
2. **Palindrome Detector** (`machines/palindrome.json`): Decides if the input string is a palindrome. Writes `y` or `n` at the end of the tape.
3. **$0^n1^n$ Language** (`machines/0n1n.json`): Decides if the input consists of $n$ zeros followed by exactly $n$ ones. Writes `y` or `n` at the end.
4. **$0^{2^n}$ Language** (`machines/02n.json`): Decides if the length of the input of zeros is a power of 2. Writes `y` or `n` at the end.
5. **Universal Turing Machine** (`machines/utm.json`): A conceptual machine designed to simulate the Unary Addition machine.

---

## Comprehensive Evaluation Test Suite

Use these test cases during peer evaluation to thoroughly test the simulator and the machines.

### 1. Unary Addition (`unary_add.json`)
Computes $A + B = C$ in unary representation (where `111` is 3, `11` is 2).

*   **Test 1.1: Standard Addition ($3 + 2 = 5$)**
    ```bash
    ./ft_turing machines/unary_add.json "111+11"
    ```
    *Expected Result:* Tape ends with `11111` (5).
    *Complexity:* ~10 steps, 7 cells.

*   **Test 1.2: Addition with 1 ($1 + 1 = 2$)**
    ```bash
    ./ft_turing machines/unary_add.json "1+1"
    ```
    *Expected Result:* Tape ends with `11` (2).

*   **Test 1.3: Large Addition ($10 + 10 = 20$)**
    ```bash
    ./ft_turing machines/unary_add.json "1111111111+1111111111"
    ```
    *Expected Result:* Tape ends with 20 ones. Observe the linear growth in Time Complexity!

---

### 2. Palindrome Detector (`palindrome.json`)
Checks if the input string reads the same backwards as forwards. Writes `y` (yes) or `n` (no) at the end.

*   **Test 2.1: Odd-length Palindrome (Accepted)**
    ```bash
    ./ft_turing machines/palindrome.json "aba"
    ```
    *Expected Result:* Tape ends with `abay` (Accepted).

*   **Test 2.2: Even-length Palindrome (Accepted)**
    ```bash
    ./ft_turing machines/palindrome.json "baab"
    ```
    *Expected Result:* Tape ends with `baaby` (Accepted).

*   **Test 2.3: Single Character Palindrome (Accepted)**
    ```bash
    ./ft_turing machines/palindrome.json "a"
    ```
    *Expected Result:* Tape ends with `ay` (Accepted).

*   **Test 2.4: Non-palindrome (Rejected)**
    ```bash
    ./ft_turing machines/palindrome.json "abc"
    ```
    *Expected Result:* Tape ends with `abcn` (Rejected).

---

### 3. $0^n1^n$ Language (`0n1n.json`)
Checks if the input consists of $n$ zeros followed by exactly $n$ ones. Writes `y` or `n` at the end.

*   **Test 3.1: Balanced String ($0^3 1^3$ - Accepted)**
    ```bash
    ./ft_turing machines/0n1n.json "000111"
    ```
    *Expected Result:* Tape ends with `000111y` (Accepted).

*   **Test 3.2: Unbalanced - Too many zeros (Rejected)**
    ```bash
    ./ft_turing machines/0n1n.json "000011"
    ```
    *Expected Result:* Tape ends with `000011n` (Rejected).

*   **Test 3.3: Unbalanced - Too many ones (Rejected)**
    ```bash
    ./ft_turing machines/0n1n.json "00111"
    ```
    *Expected Result:* Tape ends with `00111n` (Rejected).

*   **Test 3.4: Wrong Order (Rejected)**
    ```bash
    ./ft_turing machines/0n1n.json "111000"
    ```
    *Expected Result:* Tape ends with `111000n` (Rejected).

---

### 4. $0^{2^n}$ Language (`02n.json`)
Checks if the number of zeros is a power of 2 ($2^0=1$, $2^1=2$, $2^2=4$, $2^3=8$, etc.). Writes `y` or `n` at the end.

*   **Test 4.1: Power of 2 (Length 4 - Accepted)**
    ```bash
    ./ft_turing machines/02n.json "0000"
    ```
    *Expected Result:* Tape ends with `0000y` (Accepted).

*   **Test 4.2: Power of 2 (Length 1 - Accepted)**
    ```bash
    ./ft_turing machines/02n.json "0"
    ```
    *Expected Result:* Tape ends with `0y` (Accepted).

*   **Test 4.3: Power of 2 (Length 8 - Accepted)**
    ```bash
    ./ft_turing machines/02n.json "00000000"
    ```
    *Expected Result:* Tape ends with `00000000y` (Accepted).

*   **Test 4.4: Non-power of 2 (Length 3 - Rejected)**
    ```bash
    ./ft_turing machines/02n.json "000"
    ```
    *Expected Result:* Tape ends with `000n` (Rejected).

*   **Test 4.5: Non-power of 2 (Length 6 - Rejected)**
    ```bash
    ./ft_turing machines/02n.json "000000"
    ```
    *Expected Result:* Tape ends with `000000n` (Rejected).

---

### 5. Robustness & Error Handling Tests (No Crashes)

*   **Test 5.1: Invalid Characters in Input**
    ```bash
    ./ft_turing machines/unary_add.json "111+11invalid"
    ```
    *Expected Result:* Clean exit with error: `Error validating input: Input error: character 'i' is not in the alphabet.`

*   **Test 5.2: Input contains Blank Character**
    ```bash
    ./ft_turing machines/unary_add.json "111+11."
    ```
    *Expected Result:* Clean exit with error: `Error validating input: Input error: input string contains the blank character '.'.`

*   **Test 5.3: Missing JSON File**
    ```bash
    ./ft_turing machines/does_not_exist.json "111"
    ```
    *Expected Result:* Clean exit with error: `Error parsing machine: File system error...`

*   **Test 5.4: Malformed JSON (Syntax Error)**
    ```bash
    echo "{" > machines/corrupted.json
    ./ft_turing machines/corrupted.json "111"
    rm machines/corrupted.json
    ```
    *Expected Result:* Clean exit with error: `Error parsing machine: JSON syntax error...`

*   **Test 5.5: Blocked Machine (No valid transition)**
    ```bash
    ./ft_turing machines/unary_add.json "111"
    ```
    *Expected Result:* The machine starts, but halts cleanly when blocked: `Simulation halted: Machine blocked in state 'find_plus' reading character '.'.`

---

### 6. Testing the Bonus Part (Complexity Verification)

To prove to your evaluator that the complexity analyzer is mathematically accurate, run the following scaling tests. You will see how the metrics grow logically based on the size of the input.

#### A. Unary Addition Complexity Scaling (Linear $O(N)$)
As the input size increases, both Time (Steps) and Space (Tape cells) should grow linearly.

*   **Small Input (Size 3):**
    ```bash
    ./ft_turing machines/unary_add.json "1+1"
    ```
    *Expected Bonus Metrics:*
    - **Time Complexity:** 6 steps
    - **Space Complexity:** 4 cells

*   **Medium Input (Size 6):**
    ```bash
    ./ft_turing machines/unary_add.json "111+11"
    ```
    *Expected Bonus Metrics:*
    - **Time Complexity:** 10 steps
    - **Space Complexity:** 7 cells

*   **Large Input (Size 12):**
    ```bash
    ./ft_turing machines/unary_add.json "111111+11111"
    ```
    *Expected Bonus Metrics:*
    - **Time Complexity:** 18 steps
    - **Space Complexity:** 13 cells

*Conclusion:* Time Complexity is exactly $N + 4$ steps, and Space Complexity is exactly $N + 1$ cells (where $N$ is the length of the input string). This is a perfect $O(N)$ linear complexity!

#### B. Palindrome Complexity Scaling (Quadratic $O(N^2)$)
The palindrome detector moves back and forth, erasing characters from both ends. This results in quadratic time complexity.

*   **Small Palindrome (Length 3):**
    ```bash
    ./ft_turing machines/palindrome.json "aba"
    ```
    *Expected Bonus Metrics:*
    - **Time Complexity:** 18 steps
    - **Space Complexity:** 8 cells

*   **Medium Palindrome (Length 5):**
    ```bash
    ./ft_turing machines/palindrome.json "abcba"
    ```
    *Expected Bonus Metrics:*
    - **Time Complexity:** 38 steps
    - **Space Complexity:** 12 cells

*   **Large Palindrome (Length 9):**
    ```bash
    ./ft_turing machines/palindrome.json "abcdcba"
    ```
    *Expected Bonus Metrics:*
    - **Time Complexity:** 66 steps
    - **Space Complexity:** 16 cells

*Conclusion:* The number of steps grows quadratically ($O(N^2)$) relative to the input length $N$. The space complexity grows linearly ($N + \text{constant}$) because we only use a few extra cells to write the final `y`/`n` answer.

---

## License

No license is provided — use and modification for learning purposes only.



https://ocaml.org/play
