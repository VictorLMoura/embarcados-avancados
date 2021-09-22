#include <stdio.h>
#include "system.h"
#include <alt_types.h>
#include <io.h> /* Leiutura e escrita no Avalon */

int main(void){
  unsigned int counter = 0;
  unsigned int mask = 0;
  unsigned int sw_value;
  unsigned int dir = 0;
  unsigned int vel;

  while(1){
	  sw_value = IORD_32DIRECT(PIO_1_BASE, 0);
	  dir = (int) (0x08 & sw_value);
	  vel = (int) (0x07 & sw_value);

      if (counter <= 3 && sw_value > 0){
    	  if (dir > 0) {
    		  mask = 0x08 >> counter++; // 0x20 for leds
    	  } else {
        	  mask = 0x01 << counter++;
    	  }
    	  printf("%d", mask);
    	  IOWR_32DIRECT(PIO_0_BASE, 0, mask);
    	  IOWR_32DIRECT(PIO_2_BASE, 0, mask);
          usleep(16000 - vel * 2000);
      }
      else{
    	  counter = 0;
      }
  };

  return 0;
}
