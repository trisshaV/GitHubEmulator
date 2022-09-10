#! /usr/bin/env dash

#Tests tigger add
# Should successfuly add file index with no output

PATH="$PATH:$(pwd)"

# Create a temporary directory for the test.
test_dir="$(mktemp -d)"
cd "$test_dir" || exit 1

# Create some files to hold output.

expected_output="$(mktemp)"
actual_output="$(mktemp)"
tigger-init > /dev/null 2>&1


cat > "$expected_output" <<EOF
EOF
echo "a" > a

tigger-add a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

expected_output2="$(mktemp)"
actual_output2="$(mktemp)"

cat > "$expected_output2" <<EOF
tigger-add: error: can not open 'b'
EOF

tigger-add b > "$actual_output2" 2>&1

if ! diff "$expected_output2" "$actual_output2"; then
    echo "Failed test"
    exit 1
fi

trap 'rm "$expected_output" "$actual_output" "expected_output2" "actuak_output2" -rf "$test_dir"' INT HUP QUIT TERM EXIT