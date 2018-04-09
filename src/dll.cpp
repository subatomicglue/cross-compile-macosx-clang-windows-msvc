#include <stdio.h>

extern "C"
{

#if defined(WIN32)
   __declspec(dllexport)
#endif
   void init() {
      printf( "Initialized Library\nsizeof(size_t): %d\n", (int)sizeof(size_t) );
   }

}

