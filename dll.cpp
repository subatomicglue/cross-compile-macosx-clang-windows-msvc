#include <stdio.h>

extern "C"
{

   __declspec(dllexport) void vroooom() {
      printf( "Start Your Engines\n" );
   }

}

