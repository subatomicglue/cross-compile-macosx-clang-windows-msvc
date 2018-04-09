#include <stdio.h>

extern "C"
{

#if defined(WIN32)
   __declspec(dllexport)
#endif
   void vroooom() {
      printf( "Start Your Engines\nsizeof(size_t): %d\n", (int)sizeof(size_t) );
   }

}

