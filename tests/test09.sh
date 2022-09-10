#! /usr/bin/env dash

#Test tigger-rm for 
# 1. When the file in the index is different to both working file
# and repository

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
echo "line2" > a
tigger-add a 
echo "line3" > a

cat > "$expected_output" <<EOF
tigger-rm: error: 'a' in index is different to both the working file and the respository
EOF

tigger-rm a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

trap 'rm "$expected_output" "$actual_output" -rf "$test_dir"' INT HUP QUIT TERM EXIT

