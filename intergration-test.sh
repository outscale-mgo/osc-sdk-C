#!/bin/bash

set -eE

MSG_BASE="Test Example"

trap "echo [$MSG_BASE 0 FAIL]" ERR

out=$( ./example0 | grep -v '==' | jq )

[ $( echo "$out" | jq -r .Images[0].AccountAlias | grep -v null ) == "Outscale" ]

echo "[$MSG_BASE 0 OK]"

trap "echo [$MSG_BASE 1 FAIL]" ERR

./example1 | jq .Images[0].ImageName | grep Arch > /dev/null

echo "[$MSG_BASE 1 OK]"

# Yes example 3 is run before 2, because 3, create a VM, and 2 is used to destroy it
trap "echo [$MSG_BASE 3 FAIL]" ERR

./example3 -n 'test-example-3' &> /dev/null

echo "[$MSG_BASE 3 OK]"

trap "echo [$MSG_BASE 2 FAIL]" ERR

./example2 test-example-3 READ_ID &> /dev/null

./example2 test-example-3 TERMINATE_VM  'Fire ! Fire ! Fire !' &> /dev/null

echo "[$MSG_BASE 2 OK]"
