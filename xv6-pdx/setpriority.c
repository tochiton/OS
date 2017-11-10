#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  int pid = atoi(argv[1]);	
  int priority = atoi(argv[2]);	
  printf(1,"testing setting priority %d...%d\n", pid, priority);
  int rc = setpriority(pid, priority);
  if(rc == -1){
  	printf(1, "Invalid argument\n");
  }else{
  	printf(1,"The RC values is: %d\n", rc);	
  }	
  //printf(1, "***** In %s: my uid is %d\n\n", argv[0], getuid());
  exit();
}
