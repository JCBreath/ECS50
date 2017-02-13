/*	
	Author: Siyuan yao
	Date: 02/11/17
*/

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	unsigned int dividend, divisor, quotient = 0, remainder = 0;

	dividend = strtoul(argv[1], NULL, 0);
	divisor = strtoul(argv[2], NULL, 0);

    for(int i = 31; i >= 0; i--) 		/* 32-bit unsigned int */
	{
		remainder = remainder << 1; 	/* left opt (carry) */
		if(dividend & (1<<i)) 		/* check if dividend is at front */
			remainder++;		/* assign to remainder as part of dividend */
		if(remainder >= divisor)	/* if remainder is larger than divisor */
		{
			remainder -= divisor;
			quotient |= (1<<i);	/* change the specific bit of quotient to 1 */
		}
	}

	printf("%u / %u = %u R %u\n", dividend, divisor, quotient, remainder);
}
