#include <stdio.h>


int main(void) {
	register count = 13;

	register n = (count + 7) / 8;

	switch(count % 8) {
	    case 0: do {    printf("0\n");
        case 7:     printf("7\n");  
        case 6:     printf("6\n");
        case 5:     printf("5\n");
        case 4:     printf("4\n");
        case 3:     printf("3\n");
        case 2:     printf("2\n");
        case 1:     printf("1\n");
			printf("loop\n");
                } while(--n > 0);
	}
	
	return 0;

}











