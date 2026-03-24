#!/usr/bin/env bash
# DANGEROUS - if TMPDIR is unset, this becomes: rm -Rf /etc
rm -Rf "${TMPDIR}/etc" || true

# SAFE - provides fallback to /tmp
rm -Rf "${TMPDIR:-/tmp}/etc" || true
