#!/bin/bash

retfunc()
{
	    echo "this is retfunc()"
			    return 1
}

exitfunc()
{
	    echo "this is exitfunc()"
			    exit 1
}

while [[ true ]]
do
	retfunc
done

echo "We are still here"
while [[ true ]]
do
	exitfunc
done
echo "We will never see this"
