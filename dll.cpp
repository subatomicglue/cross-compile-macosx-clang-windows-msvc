#include <stdio.h>

extern "C"
{

   __declspec(dllexport) void vroooom() {
      printf( "Start Your Engines\nsizeof(size_t): %d\n", (int)sizeof(size_t) );
   }

}

