_getip() 
{
   local tmp r ip
   [ -z "$1" ] && return
   FUNREPLY=()
   tmp=$(ifconfig $1 | grep 'inet addr')
   r=${tmp/inet addr:/}
   ip=${r/ Bcast*/}
   FUNREPLY=($ip)
}
