#! /usr/bin/env dash

#Test checks to see if correct error message is printed when there
# is no change to the files being committed


PATH="$PATH:$(pwd)"

# Create a temporary directory for the test.
test_dir="$(mktemp -d)"
cd "$test_dir" || exit 1

# Create some files to hold output.

expected_output="$(mktemp)"
actual_output="$(mktemp)"
tigger-init > /dev/null 2>&1


cat > "$expected_output" <<EOF
Committed as commit 0
EOF

echo "a" > a

tigger-add a > /dev/null 2>&1

tigger-commit -m "first commit" > /dev/null 2>&1

tigger-add a > /dev/null 2>&1

tigger-commit -m "second commit" > "$actual_output" 2>&1

cat > "$expected_output" <<EOF
nothing to commit
EOF

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

trap 'rm "$expected_output" "$actual_output" "expected_output2" "actuak_output2" -rf "$test_dir"' INT HUP QUIT TERM EXIT