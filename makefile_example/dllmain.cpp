
extern "C"
{
   extern
#if defined(WIN32)
   __declspec(dllimport)
#endif
   void vroooom();
}

int main() {
   vroooom();
   return 0;
}

