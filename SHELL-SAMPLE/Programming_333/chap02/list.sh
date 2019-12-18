#!/bin/sh

# list.sh - subshell與grouping的例子

echo "First"; echo "Second"
{ echo "Alpha"; echo "Beta"; }  # subshell
( echo "One"; echo "Two" )      # grouping
