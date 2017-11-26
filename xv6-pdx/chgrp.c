#ifdef CS333_P5
#include "types.h"
#include "user.h"
int
main(int argc, char *argv[])
{
  //printf(1, "Not imlpemented yet.\n");
  if(argc < 3) exit();

  char * path = argv[2];
  int group = atoi(argv[1]);

  if(group < 0 || group > 32767){
    printf(1,"Invalid argument");
    exit();
  }
  chgrp(path, group);

  exit();
}

#endif
