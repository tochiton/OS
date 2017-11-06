#ifdef CS333_P2
#include "types.h"
#include "user.h"
#include "uproc.h"
#define max 72    //number of processes
int
main(void)
{
  // allocate my table

  struct uproc* table = malloc(max * sizeof(struct uproc));
  int result = getprocs(max, table);              // system call

  printf(1,"ID\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\tName\n");
  for(int i =0; i<result; i++){
    printf(1,"%d\t%d\t%d\t%d\t%d\t%d\t%d\t%s\t%d\t%s\t\n", table[i].pid, table[i].uid,table[i].gid, table[i].ppid, table[i].priority, table[i].elapsed_ticks, table[i].CPU_total_ticks, table[i].state, table[i].size, table[i].name );
  }

  exit();
}
#endif
