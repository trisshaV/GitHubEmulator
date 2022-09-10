#! /usr/bin/env dash

#Tests tigger init 
# Tests if correctly creates a directory, printing out the same
# success message

# CODE TAKEN FROM TUTE05 ANSWERS AS REFERENCE POINT


PATH="$PATH:$(pwd)"
# temp directory
test_dir="$(mktemp -d)"
cd "$test_dir" || exit 1

expected="$(mktemp)"
actual="$(mktemp)"

cat > "$expected" <<EOF
Initialized empty tigger repository in .tigger
EOF

tigger-init > "$actual" 2>&1

if ! diff "$expected" "$actual"; then
    echo "Failed test"
    exit 1
fi

# delete directory when test is done
trap 'rm "$expected_output" "$actual_output" -rf "$test_dir"' INT HUP QUIT TERM EXIT