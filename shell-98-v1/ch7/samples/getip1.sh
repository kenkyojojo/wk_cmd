#! /bin/bash

tmp=$(ifconfig eth0 | grep 'inet addr')
r=${tmp/inet addr:/}
ip=${r/ Bcast*/}

echo $ip
