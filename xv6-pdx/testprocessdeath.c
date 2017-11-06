#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
	printf(1,"Testing process death\n");
	int pid = fork();
	if(pid == 0){
											// add some logic here -- call wait() on the child and remove kill
		sleep(50000);						// do the same logic for wait() and exit()
	}else{
		printf(1, "Forked child\n");
		sleep(5000);
		printf(1, "Killed child\n");
		kill(pid);				// run command for zombie list
		sleep(5000);      
		wait();  			// this is the parent. kill it and exit put it into zombie 
							//waiting for a child to become a zombie
							// wait() takes out of zombie into freelist
	}
	printf(1,"%d\n", pid);
	sleep(10000);
  	exit();
}