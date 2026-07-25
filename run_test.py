#!/usr/bin/env python3
import subprocess
import os
import sys

# Output log file
LOG_FILE = "test_results.log"
EXECUTABLE = "./ft_turing"

# Define the test cases
# Format: (test_name, json_file, input_string, expected_to_fail_cli_or_blocked)
TEST_CASES = [
    # --- 1. UNARY SUBTRACTION ---
    ("Unary Sub: 5 - 2 = 3", "machines/unary_sub.json", "11111-11=", False),
    ("Unary Sub: 2 - 1 = 1", "machines/unary_sub.json", "11-1=", False),
    ("Unary Sub: 3 - 3 = 0", "machines/unary_sub.json", "111-111=", False),
    ("Unary Sub Error: No minus sign (Blocked)", "machines/unary_sub.json", "11111", True),

    # --- 2. UNARY ADDITION ---
    ("Unary Add: 3 + 2 = 5", "machines/unary_add.json", "111+11=", False),
    ("Unary Add: 1 + 1 = 2", "machines/unary_add.json", "1+1=", False),
    ("Unary Add: 10 + 10 = 20", "machines/unary_add.json", "1111111111+1111111111=", False),
    ("Unary Add: 0 + 5 = 5", "machines/unary_add.json", "+11111=", False),
    ("Unary Add Error: No plus sign (Blocked)", "machines/unary_add.json", "111", True),
    ("Unary Add Error: Invalid character", "machines/unary_add.json", "111+11a", True),

    # --- 3. PALINDROME (0/1) ---
    ("Palindrome: '010' (Odd length - Yes)", "machines/palindrome.json", "010", False),
    ("Palindrome: '0110' (Even length - Yes)", "machines/palindrome.json", "0110", False),
    ("Palindrome: '1' (Single char - Yes)", "machines/palindrome.json", "1", False),
    ("Palindrome: '10' (No)", "machines/palindrome.json", "10", False),
    ("Palindrome: '' (Empty - Yes)", "machines/palindrome.json", "", False),
    ("Palindrome Error: Invalid character", "machines/palindrome.json", "012", True),

    # --- 4. PALINDROME (a/b) ---
    ("Palindrome_x: 'aba' (Odd length - Yes)", "machines/palindrome_x.json", "aba", False),
    ("Palindrome_x: 'abba' (Even length - Yes)", "machines/palindrome_x.json", "abba", False),
    ("Palindrome_x: 'a' (Single char - Yes)", "machines/palindrome_x.json", "a", False),
    ("Palindrome_x: 'ab' (No)", "machines/palindrome_x.json", "ab", False),
    ("Palindrome_x: '' (Empty - Yes)", "machines/palindrome_x.json", "", False),
    ("Palindrome_x Error: Invalid character", "machines/palindrome_x.json", "abc", True),

    # --- 5. 0n1n LANGUAGE ---
    ("0n1n: '000111' (Balanced - Yes)", "machines/0n1n.json", "000111", False),
    ("0n1n: '000011' (Too many 0s - No)", "machines/0n1n.json", "000011", False),
    ("0n1n: '00111' (Too many 1s - No)", "machines/0n1n.json", "00111", False),
    ("0n1n: '111000' (Wrong order - No)", "machines/0n1n.json", "111000", False),
    ("0n1n: '' (Empty - Yes)", "machines/0n1n.json", "", False),
    ("0n1n Error: Invalid character", "machines/0n1n.json", "00112", True),

    # --- 6. 0^2n LANGUAGE ---
    ("0^2n: '00' (Length 2 - Yes)", "machines/02n.json", "00", False),
    ("0^2n: '0000' (Length 4 - Yes)", "machines/02n.json", "0000", False),
    ("0^2n: '00000000' (Length 8 - Yes)", "machines/02n.json", "00000000", False),
    ("0^2n: '0' (Length 1 - No)", "machines/02n.json", "0", False),
    ("0^2n: '000' (Length 3 - No)", "machines/02n.json", "000", False),
    ("0^2n: '000000' (Length 6 - No)", "machines/02n.json", "000000", False),
    ("0^2n: '' (Empty - Yes)", "machines/02n.json", "", False),
    ("0^2n Error: Invalid character", "machines/02n.json", "0010", True),

    # --- 7. UNIVERSAL TURING MACHINE (simulates unary_add) ---
    ("UTM: 3 + 2 = 5", "machines/utm_unary_add.json", "A#111+11=", False),
    ("UTM: 1 + 1 = 2", "machines/utm_unary_add.json", "A#1+1=", False),
    ("UTM: 10 + 10 = 20", "machines/utm_unary_add.json", "A#1111111111+1111111111=", False),
    ("UTM: 0 + 5 = 5", "machines/utm_unary_add.json", "A#+11111=", False),
    ("UTM: Start from state B", "machines/utm_unary_add.json", "B#111+11=", True),
    ("UTM Error: Invalid state (blocked)", "machines/utm_unary_add.json", "Z#111+11=", True),
    ("UTM Error: Missing separator (blocked)", "machines/utm_unary_add.json", "A111+11=", True),

    # --- 8. ROBUSTNESS & CLI ---
    ("CLI Error: Missing JSON file", "machines/does_not_exist.json", "111", True),
    ("CLI Error: Empty input string", "machines/unary_add.json", "", True),
    ("CLI Error: Wrong number of arguments", "machines/unary_add.json", "", True),
]

def run_command(cmd):
    """Runs a shell command and returns (stdout, stderr, returncode)"""
    process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    stdout, stderr = process.communicate()
    return stdout.decode('utf-8', errors='ignore'), stderr.decode('utf-8', errors='ignore'), process.returncode

def main():
    # 1. Check if executable exists
    if not os.path.exists(EXECUTABLE):
        print(f"Error: {EXECUTABLE} not found. Please run 'make' first.")
        sys.exit(1)

    print("==================================================")
    print("          FT_TURING AUTOMATED TEST SUITE          ")
    print("==================================================")
    print(f"Running tests and saving details to: {LOG_FILE}\n")

    with open(LOG_FILE, "w") as log:
        log.write("==================================================\n")
        log.write("          FT_TURING AUTOMATED TEST LOGS           \n")
        log.write("==================================================\n\n")

        success_count = 0
        total_tests = len(TEST_CASES)

        for idx, (name, json_file, input_str, expected_fail) in enumerate(TEST_CASES, 1):
            cmd = f"{EXECUTABLE} {json_file} \"{input_str}\""
            log.write(f"--- TEST {idx}: {name} ---\n")
            log.write(f"Command: {cmd}\n")
            log.write("-" * 50 + "\n")

            stdout, stderr, code = run_command(cmd)

            log.write("[STDOUT]\n")
            log.write(stdout if stdout else "(No stdout)\n")
            log.write("\n[STDERR]\n")
            log.write(stderr if stderr else "(No stderr)\n")
            log.write(f"\nExit Code: {code}\n")
            log.write("=" * 80 + "\n\n")

            # Determine if the test behavior was correct
            has_failed = (code != 0) or ("blocked" in stdout.lower()) or ("error" in stderr.lower())
            
            if expected_fail == has_failed:
                status = "OK"
                success_count += 1
                print(f"[{idx:02d}/{total_tests:02d}] \033[92mPASS\033[0m: {name}")
            else:
                status = "FAIL"
                print(f"[{idx:02d}/{total_tests:02d}] \033[91mFAIL\033[0m: {name} (Expected fail: {expected_fail}, Got fail: {has_failed})")

        print("\n==================================================")
        if success_count == total_tests:
            print(f"\033[92mALL TESTS PASSED ({success_count}/{total_tests})\033[0m")
        else:
            print(f"\033[91mSOME TESTS FAILED ({success_count}/{total_tests})\033[0m")
        print(f"Detailed logs saved in: {LOG_FILE}")
        print("==================================================")

if __name__ == "__main__":
    main()
