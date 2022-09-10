#! /usr/bin/env dash

# Test tigger-log with commits

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
echo "line3" >> a
tigger-add a
tigger-commit -m "third commit" > /dev/null 2>&1
echo "line 1" > b 
tigger-add b
tigger-commit -m "new file" > /dev/null 2>&1

cat > "$expected_output" <<EOF
3 new file
2 third commit
1 second commit
0 first commit
EOF

tigger-log > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

trap 'rm "$expected_output" "$actual_output" -rf "$test_dir"' INT HUP QUIT TERM EXIT
