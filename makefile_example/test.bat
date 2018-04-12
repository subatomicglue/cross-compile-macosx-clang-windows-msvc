
:: windows binary tests (to test native, go run ./test under a bash shell)
:: run test.bat under cmd.exe
::
::    C:\cross-windows> test.bat
::
:: to test the architecture of the .exe files:
::
::   "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\dumpbin" /headers *.exe
::

mainC-x86.exe
mainC-x64.exe

mainC-x86-cl.exe
mainC-x64-cl.exe

mainCPP-x64.exe
mainCPP-x86.exe

mainCPP-x86-cl.exe
mainCPP-x64-cl.exe

libmain-x86.exe
libmain-x64.exe

dllmain-x86.exe
dllmain-x64.exe

pluginmain-x86.exe
pluginmain-x64.exe

