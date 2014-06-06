#!/bin/sh -x

to_log() {
	echo "`date \"+%b %m %H:%M:%S\"` $1 " >> /tmp/scott/tt.out
}

to_log hihi

