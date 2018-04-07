
extern "C"
{
   extern
#ifdef WINDOWS
   __declspec(dllimport)
#endif
   void vroooom();
}

int main() {
   vroooom();
   return 0;
}

