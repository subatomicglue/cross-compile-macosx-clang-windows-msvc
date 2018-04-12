
:: windows binary tests (to test native, go run ./test under a bash shell)
:: run test.bat under cmd.exe
::
::    C:\cross-windows> test.bat
::
:: to test the architecture of the .exe files:
::
::   "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\dumpbin" /headers *.exe
::



build-wincross32\mainCPP-x86.exe
build-wincross64\mainCPP-x64.exe

build-wincross32\mainC-x86.exe
build-wincross64\mainC-x64.exe

build-wincross32\mainCPP-x86-cl.exe
build-wincross64\mainCPP-x64-cl.exe

build-wincross32\mainC-x86-cl.exe
build-wincross64\mainC-x64-cl.exe

build-wincross32\libmain-x86.exe
build-wincross64\libmain-x64.exe

build-wincross32\dllmain-x86.exe
build-wincross64\dllmain-x64.exe

:: in bash shell, you have to run from the directory .exe is in
:: in order for the plugin to be found in same dir
:: seems not to be an issue for cmd.exe however.

build-wincross32\pluginmain-x86.exe
build-wincross64\pluginmain-x64.exe

