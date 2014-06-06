#!/usr/bin/ksh93

cat /dev/null > $0.log
#IP_config DAP1-x
i=1
while [ $i -le 40 ];

do

echo "/usr/sbin/mktcpip -h DAP1-${i} -a 10.240.102.${i} -m '255.255.255.0' -i en0;/usr/sbin/mktcpip -h DAP1-${i} -a 10.204.102.${i} -m '255.255.255.0' -i en1 -g '10.204.102.254';chdev -l inet0 -a route=\"host,-hopcount,0,,,,,,-static,10.71.0.0,10.204.102.254\"" > host.cmd
echo "ssh -p 2222 DAP1-${i} `head -1 host.cmd`" >> $0.log
ssh -p 2222 DAP1-${i} `head -1 host.cmd`
((i=i+1))
done


#IP_config DAP2-x
i=1
j=51
while [ $i -le 40 ];
do

echo "/usr/sbin/mktcpip -h DAP2-${i} -a 10.240.102.${j} -m '255.255.255.0' -i en0;/usr/sbin/mktcpip -h DAP2-${i} -a 10.204.102.${j} -m '255.255.255.0' -i en1 -g '10.204.102.254';chdev -l inet0 -a route=\"host,-hopcount,0,,,,,,-static,10.71.0.0,10.204.102.254\"" > host.cmd
echo "ssh -p 2222 DAP2-${i} `head -1 host.cmd`" >> $0.log
ssh -p 2222 DAP2-${i} `head -1 host.cmd`
((i=i+1))
((j=j+1))
done

#ip_config LOG
i=1
while [ $i -le 2 ];
do
echo "/usr/sbin/mktcpip -h LOG${i} -a 10.204.3.12${i} -m '255.255.255.0' -i en0;/usr/sbin/mktcpip -h LOG${i} -a 10.240.102.12${i} -m '255.255.255.0' -i en1;/usr/sbin/mktcpip -h LOG${i} -a 10.199.168.12${i} -m '255.255.255.0' -i en2;/usr/sbin/mktcpip -h LOG${i} -a 10.201.1.3${i} -m '255.255.255.0' -i en4 -g '10.201.1.254'" > host.cmd
echo "ssh -p 2222 LOG${i} `head -1 host.cmd`" >> $0.log
ssh -p 2222 LOG${i} `head -1 host.cmd`
((i=i+1))
done

#ip_config MDS
i=1
while [ $i -le 2 ];
do
echo "/usr/sbin/mktcpip -h MDS${i} -a 10.204.3.11${i} -m '255.255.255.0' -i en0;/usr/sbin/mktcpip -h MDS${i} -a 10.240.102.11${i} -m '255.255.255.0' -i en1;/usr/sbin/mktcpip -h MDS${i} -a 10.199.168.11${i} -m '255.255.255.0' -i en2" > host.cmd
echo "ssh -p 2222 MDS${i} `head -1 host.cmd`" >> $0.log
ssh -p 2222 MDS${i} `head -1 host.cmd`
((i=i+1))
done

#ip_config DAR1-X
i=1
while [ $i -le 4 ];
do
echo "/usr/sbin/mktcpip -h DAR1-${i} -a 10.240.102.13${i} -m '255.255.255.0' -i en0;/usr/sbin/mktcpip -h DAR1-${i} -a 10.204.102.13${i} -m '255.255.255.0' -i en1;/usr/sbin/mktcpip -h DAR1-${i} -a 10.199.168.13${i} -m '255.255.255.0' -i en2;chdev -l inet0 -a route=\"host,-hopcount,0,,,,,,-static,10.71.0.0,10.204.102.254\"" > host.cmd
echo "ssh -p 2222 DAR1-${i} `head -1 host.cmd`" >> $0.log
ssh -p 2222 DAR1-${i} `head -1 host.cmd`
((i=i+1))
done

#ip_config DAR2-X
i=1
j=6
while [ $i -le 4 ];
do
echo "/usr/sbin/mktcpip -h DAR2-${i} -a 10.240.102.13${j} -m '255.255.255.0' -i en0;/usr/sbin/mktcpip -h DAR2-${i} -a 10.204.102.13${j} -m '255.255.255.0' -i en1;/usr/sbin/mktcpip -h DAR2-${i} -a 10.199.168.13${j} -m '255.255.255.0' -i en2;chdev -l inet0 -a route=\"host,-hopcount,0,,,,,,-static,10.71.0.0,10.204.102.254\"" > host.cmd
echo "ssh -p 2222 DAR2-${i} `head -1 host.cmd`" >> $0.log
ssh -p 2222 DAR2-${i} `head -1 host.cmd`
((i=i+1))
((j=j+1))
done

rm -f host.cmd

