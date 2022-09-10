#! /usr/bin/env dash

#Tests for invalid filename, should print out the correct error message

PATH="$PATH:$(pwd)"

# Create a temporary directory for the test.
test_dir="$(mktemp -d)"
cd "$test_dir" || exit 1

# Create some files to hold output.

expected_output="$(mktemp)"
actual_output="$(mktemp)"
tigger-init > /dev/null 2>&1

cat > "$expected_output" <<EOF
tigger-add: error: invalid filename
EOF

echo "a" > **

tigger-add ** > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
