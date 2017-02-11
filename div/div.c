#include <stdio.h>
#include <stdlib.h>

unsigned int dd, ds; /*DiviDend and DiviSor*/

int main(int argc, char *argv[]) 
{
	int i, j;
	dd = atoi(argv[1]);
	ds = atoi(argv[2]);
	
	for(i=7; i>=0; i--)
		if(dd & (1 << i))
			break;

	for(j=7; j>=0; j--)
		if(ds & (1 << j))
			break;

	printf("%d\n", i + 1);
	printf("%u\n", dd);
}
