#! /usr/bin/env dash

#Test tigger-show that prints out an error message in two seperate situations:
# 1. The file has isn't updated to the most current commit
# 2. The file does not exist to the most current commit number

PATH="$PATH:$(pwd)"

# Create a temporary directory for the test.
test_dir="$(mktemp -d)"
cd "$test_dir" || exit 1

# Create some files to hold output.

expected_output="$(mktemp)"
actual_output="$(mktemp)"
tigger-init > /dev/null 2>&1

echo "line1"> a 
tigger-add a 
tigger-commit -m "first commit" > /dev/null 2>&1
echo "line2" >> a 
tigger-add a 
tigger-commit -m "second commit" > /dev/null 2>&1

cat > "$expected_output" <<EOF
tigger-show: error: 'b' not found in commit 1
EOF

tigger-show 1:b > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

tigger-show 3:a > "$actual_output" 2>&1

cat > "$expected_output" <<EOF
tigger-show: error: unknown commit '3'
EOF

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

trap 'rm "$expected_output" "$actual_output" -rf "$test_dir"' INT HUP QUIT TERM EXIT

