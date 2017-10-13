#ifdef CS333_P2
#include "types.h"
#include "user.h"
int
main(int argc, char *argv[])
{
	if(argc == 1){
		printf(2, "ran in 0.00 seconds\n");
		exit();
	}
	int time_start = uptime();
	int pid = fork();

	if(pid < 0){
		printf(2, "time failed: invalid pid\n");
		exit();	
	}

	if(pid == 0){
		++argv; 
		if(exec(argv[0], argv)){
			printf(2, "time failed: exec failed\n");
			exit();	
		}  
	}
	wait();
	int time_end = uptime();
	int total_time = time_end - time_start;
	int seconds = total_time/100;
	int finalTime = total_time % 100;
	printf(1, "%s ran in %d.%d seconds\n",argv[1], seconds, finalTime);
	exit();
}

#endif
