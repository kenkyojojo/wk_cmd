#!/bin/ksh
#if [ $# -ne 1 ]; then
if [ $# -lt 1 ]; then
  echo "usage: $0 <pattern>"
  exit 0
fi

#NAME_PATTERN=\"$1\"
NAME_PATTERN=`ls /tmp/*txt`
export NAME_PATTERN
cat <<\ENDMARKER > iomon.e
int open (char *Path, int OFlag , int Mode);
int count;
@@BEGIN
{
   printf("begin probing\n");
   count = 0;
}

@@syscall:*:open:entry
{
  String filename[128];
  filename = get_userstring(__arg1, -1);

  if(strstr(filename, $NAME_PATTERN))
  {
    if(__arg2 != 0)
    {
      printf("\n\nProgram <%s>, Pid <%ld>,  Tid <%ld> opened %s\n", __pname, __pid, __tid, filename);
      printf("oflag = %d, mode = %d \n", __arg2, __arg3);
      stktrace(PRINT_SYMBOLS | GET_USER_TRACE, -1);
      count++;
    }
  }
}

@@interval:*:clock:60000
{
    printf("%d event traced\n", count);
}
ENDMARKER
probevue -o probe`date '+%Y-%m-%d-%H-%M-%S'`.out iomon.e

