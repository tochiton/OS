#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
	printf(1,"Testing process death\n");
	int pid = fork();
	printf(1,"%d\n", pid);
	sleep(10000);
  	exit();
}