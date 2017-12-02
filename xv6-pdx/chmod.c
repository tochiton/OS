#ifdef CS333_P5
#include "types.h"
#include "user.h"

static int
convert(const char *s)
{
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
    n = n*8 + *s++ - '0';
  return sign*n;
}
int
main(int argc, char *argv[])
{
  if(argc < 3) exit();

  char * path = argv[2];
  int mode = convert(argv[1]);
  //printf(1,"%d\n", mode);
  // convert char to int
  // four digits at a time
  // the first one is zero
  
  if(00000 > mode || mode > 01777){
  	printf(1,"Invalid argument");
  }
  chmod(path, mode);
  
  exit();
}


#endif
