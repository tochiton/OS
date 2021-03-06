#include "types.h"
#include "user.h"

static void 
forkTest(uint nval){
 uint uid, gid;
 int pid; 
 printf(1, "setting UID to: %d and Setting GID to: %d before fork()\n", nval, nval);
 
 if(setuid(nval) < 0)
   printf(2, "Invalid uid %d\n", nval);
 
 if(setgid(nval) < 0)
   printf(2, "Invalid gid %d\n", nval);


 uid = getuid();
 printf(2, "Current uid is: %d\n", uid);

 pid = fork();
 if(pid == 0){
   uid = getuid();
   gid = getgid();
   printf(1, "Child UID is: %d, GID is: %d\n", uid, gid);
   sleep(2* TPS);
   exit(); 
 }else
   sleep(2* TPS);
}

int
testuidgid(void){
  uint uid, gid, ppid;
  // check for out of range value for negative test  
  forkTest(100);
  uid = getuid();
  printf(2, "Current UID is: %d\n", uid);
  printf(2, "Setting UID to 100\n");
  setuid(100);
  uid = getuid();
  printf(2, "Current UID is: %d\n", uid);

  gid = getgid();
  printf(2, "Current GID is: %d\n", gid);
  printf(2, "Setting GID to 100\n");
  setgid(100);
  gid = getgid();
  printf(2, "Current GID is: %d\n", gid);

  ppid = getppid();
  printf(2, "My parent process  is: %d\n", ppid);
  printf(2, "Done!\n");
  
  return 0;
}

void
testSched(){
  int ret = 1;
  for(int i = 0; i < 10 && ret != 0; ++i) 
  ret = fork();

  if(ret == 0)
    for(;;);
  exit();
}

int
main(int argc, char *argv[])
{
  //int temp = testuidgid(); 
  //printf(1,"temp: %d\n", temp); 
  testSched();
  exit();
}
