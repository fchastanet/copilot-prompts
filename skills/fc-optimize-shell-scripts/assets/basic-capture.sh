#!/usr/bin/env bash

# Always assign to variable first (don't use in echo directly)
local output
output="$(functionThatOutputSomething "${arg1}")"
