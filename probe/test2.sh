#!/bin/ksh
cat <<\ENDMARKER > iomon.e
@@BEGIN
{
  int open (const char *Path, int OFlag , int Mode);
  int count;
  count = 0;
}

@@syscall:*:open:entry
{
  __auto String fname[128];
  __auto String pattern[32];
  pattern = "objrepos";
  fname = get_userstring(__arg1, -1);
  
  if(strstr(fname, pattern))
  {
    if(__arg2 != 0)
    {
      printf("\n\nProgram <%s>, Pid <%ld>,  Tid <%ld> entered\n", __pname, __pid, __tid);
      printf("file = %s, oflag = %d, mode = %d \n", fname, __arg2, __arg3);
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
