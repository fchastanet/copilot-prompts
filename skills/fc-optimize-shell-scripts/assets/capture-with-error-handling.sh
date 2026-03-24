#!/usr/bin/env bash
local output
output="$(functionThatOutputSomething "${arg1}")" || {
  echo "error"
  exit 1
}
