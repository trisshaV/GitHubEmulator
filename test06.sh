#! /usr/bin/env dash

#Test tigger-show with a file that doesnt exist in the repo,
# should print out the correct error message


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


cat > "$expected_output" <<EOF
tigger-show: error: unknown commit 'b'
EOF

tigger-show b > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

trap 'rm "$expected_output" "$actual_output" -rf "$test_dir"' INT HUP QUIT TERM EXIT
