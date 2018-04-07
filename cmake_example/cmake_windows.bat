
:: build from native Windows CMD prompt
::   C:\...> cmake_windows.bat


:: build 32 bit

setlocal
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86

rmdir /S /Q build-win32
mkdir build-win32 & pushd build-win32
cmake -DCMAKE_TOOLCHAIN_FILE=Modules\Native32.cmake -G "Visual Studio 14" ..
popd

cmake --build build-win32 --config Release

endlocal


:: build 64 bit

setlocal
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64

rmdir /S /Q build-win64
mkdir build-win64 & pushd build-win64
cmake -DCMAKE_TOOLCHAIN_FILE=Modules\Native64.cmake -G "Visual Studio 14 Win64" ..
popd

cmake --build build-win64 --config Release

endlocal

