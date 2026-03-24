#!/usr/bin/env bash
tempDir="${TMPDIR:-/tmp}/myapp-$$"
mkdir -p "${tempDir}"

# Or use mktemp
tempDir="$(mktemp -d)"
