#!/bin/bash

# lineno.sh - 取得現在的行號

func() {
    echo "lineno.sh($LINENO): func()"
}

echo "lineno.sh($LINENO): main entry"
func
func
