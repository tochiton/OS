#include "types.h"
#include "user.h"


void
testSched(){
  int ret = 1;
  for(int i = 0; i < 10 && ret != 0; ++i) 
  ret = fork();

  if(ret == 0)
    for(;;);
  exit();
}
//creates a process
void
testList(){
  sleep(5000);
  printf(1,"Finished sleeping for 5 seconds \n ");
  exit();
}

int
main(int argc, char *argv[])
{
  //testSched();
  testList();
  exit();
}
