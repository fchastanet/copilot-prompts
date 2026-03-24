#!/usr/bin/env bash
declare output status
output="$(functionThatOutputSomething "${arg1}")"; status=$?
echo "${status}"
