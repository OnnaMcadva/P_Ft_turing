#!/usr/bin/env python3
"""
bonus_test.py — measures how step count (time) and tape usage (space)
grow as a function of input size, for the Turing machines in this project.

This directly targets the subject's bonus requirement:
    "allow your program to compute the time complexity of the executed algorithm"

Method: for each machine, run on inputs of increasing size n, record steps
and tape cells used (parsed from the program's own bonus output), then look
at the ratio of consecutive measurements relative to the ratio of n. If
n doubles and steps roughly double too -> linear growth (O(n)). If steps
roughly quadruple -> quadratic growth (O(n^2)). Etc.

Note on interpretation: the ratio/n_ratio quotient for a fixed-degree
polynomial complexity converges to a constant as n grows (1 for O(n),
2 for O(n^2), etc), but at small n it is skewed downward by constant
overhead (startup/halt steps that don't scale with n). So the quotient
from the LARGEST n pair is used as the asymptotic estimate, not the
average across all pairs.
"""
import subprocess
import re
import sys
import os

EXECUTABLE = "./ft_turing"
LOG_FILE = "bonus_results.log"

STEPS_RE = re.compile(r"Time Complexity \(Steps executed\)\s*:\s*(\d+)")
SPACE_RE = re.compile(r"Space Complexity \(Tape cells used\)\s*:\s*(\d+)")

# ANSI color codes (e.g. "\x1b[1;32m") appear in the program's colored output
# and break the regexes above if left in, since they sit between ":" and the
# digits. Strip them before matching.
ANSI_ESCAPE_RE = re.compile(r'\x1b\[[0-9;]*m')

def strip_ansi(text):
    return ANSI_ESCAPE_RE.sub('', text)

# ---------------------------------------------------------------------------
# Input generators: for a given "size" n, build a valid input string for
# each machine.
# ---------------------------------------------------------------------------

def gen_unary_add(n):
    return "1" * n + "+" + "1" * n + "="

def gen_unary_sub(n):
    # a = 2n, b = n -> always non-negative, avoids blocking on negative result
    return "1" * (2 * n) + "-" + "1" * n + "="

def gen_palindrome(n):
    # binary palindrome of length 2n, always valid
    half = "01" * (n // 2) + ("0" if n % 2 else "")
    return half + half[::-1]

def gen_palindrome_x(n):
    # same idea, alphabet a/b
    half = "ab" * (n // 2) + ("a" if n % 2 else "")
    return half + half[::-1]

def gen_0n1n(n):
    return "0" * n + "1" * n

def gen_02n(n):
    return "0" * (2 * n)

MACHINES = [
    ("unary_add",    "machines/unary_add.json",   gen_unary_add,    [5, 10, 20, 40, 80]),
    ("unary_sub",    "machines/unary_sub.json",    gen_unary_sub,    [5, 10, 20, 40, 80]),
    ("palindrome",   "machines/palindrome.json",   gen_palindrome,   [4, 8, 16, 32, 64]),
    ("palindrome_x", "machines/palindrome_x.json", gen_palindrome_x, [4, 8, 16, 32, 64]),
    ("0n1n",         "machines/0n1n.json",          gen_0n1n,         [5, 10, 20, 40, 80]),
    ("02n",          "machines/02n.json",           gen_02n,          [5, 10, 20, 40, 80]),
]

# ---------------------------------------------------------------------------

def run_machine(json_file, input_str):
    cmd = [EXECUTABLE, json_file, input_str]
    result = subprocess.run(cmd, capture_output=True, text=True)
    clean_stdout = strip_ansi(result.stdout)
    steps_match = STEPS_RE.search(clean_stdout)
    space_match = SPACE_RE.search(clean_stdout)
    if not steps_match or not space_match:
        return None, None
    return int(steps_match.group(1)), int(space_match.group(1))

def classify(asymptotic_ratio):
    if asymptotic_ratio < 1.3:
        return "O(n) — linear"
    elif asymptotic_ratio < 1.7:
        return "O(n log n) or mild super-linear"
    else:
        return "O(n^2) — quadratic (ratio approaching 2 as n grows)"

def analyze(sizes, values, label, log):
    """
    Prints and logs, for each consecutive pair of measurements, the n-ratio,
    the value-ratio, and their quotient (the growth exponent estimate).
    Uses the quotient from the largest-n pair as the asymptotic estimate,
    since small-n ratios are skewed by constant overhead.
    """
    print(f"\n  {label} growth analysis:")
    print(f"  {'n_i -> n_j':>14} | {'n ratio':>8} | {label[:5]+' ratio':>12} | {'ratio/n_ratio':>14}")
    log.write(f"\n{label} growth analysis:\n")

    quotients = []
    for i in range(1, len(sizes)):
        n_ratio = sizes[i] / sizes[i - 1]
        if values[i - 1] == 0:
            continue
        v_ratio = values[i] / values[i - 1]
        quotient = v_ratio / n_ratio
        quotients.append(quotient)
        line = f"  {sizes[i-1]:>5} -> {sizes[i]:<5} | {n_ratio:>8.2f} | {v_ratio:>12.2f} | {quotient:>14.2f}"
        print(line)
        log.write(line + "\n")

    if not quotients:
        print("  insufficient data")
        log.write("  insufficient data\n")
        return None, "insufficient data"

    avg = sum(quotients) / len(quotients)
    asymptotic = quotients[-1]
    order = classify(asymptotic)
    summary = (
        f"  => average ratio/n_ratio = {avg:.2f}, "
        f"asymptotic (largest n) ratio/n_ratio = {asymptotic:.2f}  =>  {order}"
    )
    print(summary)
    log.write(summary + "\n")
    return asymptotic, order

def main():
    if not os.path.exists(EXECUTABLE):
        print(f"Error: {EXECUTABLE} not found. Run 'make' first.")
        sys.exit(1)

    print("=" * 80)
    print("  FT_TURING — TIME & SPACE COMPLEXITY MEASUREMENT (BONUS)")
    print("=" * 80)
    print("  Method: run each machine on inputs of growing size n, read the")
    print("  program's own step count (time) and tape usage (space), and")
    print("  compare consecutive ratios against the ratio of n to estimate")
    print("  the order of growth (linear / quadratic / etc). The largest-n")
    print("  pair is used as the asymptotic estimate (small-n ratios are")
    print("  skewed by constant per-run overhead).")

    with open(LOG_FILE, "w") as log:
        log.write("FT_TURING — TIME & SPACE COMPLEXITY MEASUREMENT (BONUS)\n")
        log.write("=" * 60 + "\n")

        for name, json_file, gen, sizes in MACHINES:
            print("\n" + "=" * 80)
            print(f"  MACHINE: {name}")
            print("=" * 80)
            log.write(f"\n\n=== {name} ===\n")

            print(f"{'n':>6} | {'input len':>10} | {'steps':>10} | {'tape cells':>10}")
            print("-" * 46)

            n_values, step_values, space_values = [], [], []

            for n in sizes:
                input_str = gen(n)
                steps, space = run_machine(json_file, input_str)
                if steps is None:
                    print(f"{n:>6} | {'ERROR':>10} | {'-':>10} | {'-':>10}")
                    log.write(f"n={n}: FAILED to run or parse output for input={input_str!r}\n")
                    continue
                print(f"{n:>6} | {len(input_str):>10} | {steps:>10} | {space:>10}")
                log.write(f"n={n} input_len={len(input_str)} steps={steps} space={space}\n")
                n_values.append(n)
                step_values.append(steps)
                space_values.append(space)

            if len(n_values) >= 2:
                analyze(n_values, step_values, "steps (TIME)", log)
                analyze(n_values, space_values, "cells (SPACE)", log)
            else:
                print("  insufficient data points to estimate complexity")
                log.write("  insufficient data points to estimate complexity\n")

    print("\n" + "=" * 80)
    print(f"Full results saved in: {LOG_FILE}")
    print("=" * 80)

if __name__ == "__main__":
    main()
