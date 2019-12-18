#!/bin/bash

# ucrun.sh - ¹Է̤ξʸʸѴƽ

#
# usage: ucrun.sh [command] [arg ...]
#

"$@" 2>&1 | tr 'a-z' 'A-Z'
exit ${PIPESTATUS[0]}
