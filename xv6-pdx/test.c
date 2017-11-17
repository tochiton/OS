#include "types.h"
#include "user.h"


void
testSched(){
  int ret = 1;
  int i;
  for(i = 0; i < 6 && ret != 0; ++i) 
  ret = fork();

  if(ret == 0){
      //setpriority(getpid(),6);
      //sleep(500000);
    for(;;);
  }
  exit();
}
void
testMLFQ(){
  int ret = 1;
  int i;
  for(i = 0; i < 6 && ret != 0; ++i) 
  ret = fork();

  if(ret == 0){
      setpriority(getpid(),6);
      //sleep(500000);
    for(;;);
  }
  exit();
}
//creates a process
void
testList(){
  int process = fork();
  if(process == 0)
    sleep(50000);
  printf(1,"Finished sleeping for 5 seconds \n ");
  exit();
}

int
main(int argc, char *argv[])
{
  testSched();            // test round - robin
  //testMLFQ();
  //testList();             // test free list
  exit();
}
