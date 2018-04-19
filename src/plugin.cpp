#include <stdio.h>

extern "C"
{

#if defined(WIN32)
   __declspec(dllexport)
#endif
   void vroooom() {
      printf( "Start Your Engines\nsizeof(size_t): %d\n", (int)sizeof(size_t) );
   }

   // we'll export this with a .def file...
   void crash() {
      printf( "Crash!\nsizeof(size_t): %d\n", (int)sizeof(size_t) );
   }
}

