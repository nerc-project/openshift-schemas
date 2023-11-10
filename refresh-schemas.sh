#!/bin/sh

tmpfile=$(mktemp schemaXXXXXX)
trap "rm -f $tmpfile" EXIT

set -e

./schemautil -v fetch -o "$tmpfile"
./schemautil -v split -d schemas "$@" "$tmpfile"
./schemautil -v kustomize schemas
