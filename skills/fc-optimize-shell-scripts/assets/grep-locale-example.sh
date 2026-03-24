#!/usr/bin/env bash

# Match only ASCII alphanumeric and underscore using POSIX locale
LC_ALL=POSIX grep -E -q '^[A-Za-z_0-9:]+$'
