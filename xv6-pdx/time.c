#ifdef CS333_P2
#include "types.h"
#include "user.h"
	int
main(int argc, char *argv[])
{
	// ++argv;
	int time_start = uptime();
	int pid = fork();

	if(pid < 0){
		printf(2, "time failed: invalid pid\n");
		exit();	
	}

	if(pid == 0){
		if(argc == 1)
			exit(); 
		++argv; 
		if(exec(argv[0], argv)){
			printf(2, "time failed: exec failed\n");
			exit();	
		}  
	}
	wait();
	int time_end = uptime();
	int total_time = time_end - time_start;
	printf(1, "%d\n",total_time);
	exit();
}

#endif
