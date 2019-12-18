#!/bin/sh

# source_main.sh - source指令的例子(讀入函數的一方)

. ./source_sub.sh

get_systype  #讀入source_sub.sh函數

echo "Machine hardware: $MACHINE"
echo "  Processor type: $PROCESSOR"
echo "Operating system: $OS"
