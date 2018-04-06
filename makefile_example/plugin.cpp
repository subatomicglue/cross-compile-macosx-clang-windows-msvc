
#include <stdio.h>
#include "Windows.h"

typedef void (*vroooom_func)();

int main()
{
   HMODULE module;
   if (sizeof(size_t) == 8)
   {
      printf( "Loading DLL plugin 'dll-x64.dll':\n" );
      module = LoadLibrary("dll-x64.dll");
   }
   else
   {
      printf( "Loading DLL plugin 'dll-x86.dll':\n" );
      module = LoadLibrary("dll-x86.dll");
   }

   if (module == 0)
   {
      printf( "Couldn't load DLL plugin\n" );
      exit(-1);
   }

   printf( "Finding plugin entrypoint 'vroooom':\n" );
   vroooom_func vroooom = (vroooom_func)GetProcAddress( module, "vroooom" );
   if (vroooom)
   {
      printf( "Found 'vroooom', calling:\n" );
      vroooom();
   }
   else
   {
      printf( "Couldn't find 'vroooom' in DLL plugin\n" );
   }
}
