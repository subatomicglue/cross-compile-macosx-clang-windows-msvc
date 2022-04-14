
:: build from native Windows CMD prompt
::   C:\...> cmake_windows.bat






:: build 64 bit

setlocal
::call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
rmdir /S /Q build-win64
mkdir build-win64 & pushd build-win64
::cmake -DCMAKE_TOOLCHAIN_FILE=Modules\Native64.cmake -G "Visual Studio 14 Win64" ..
cmake -DCMAKE_TOOLCHAIN_FILE=Modules\Windows64.cmake -G "Visual Studio 17 2022" -A x64 ..
cmake --build . --config Debug
cmake --build . --config Release
popd
endlocal


:: build 32 bit (deprecated, stop supporting Windows 32bit...)

:: setlocal
:: ::call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86
:: call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x86
:: rmdir /S /Q build-win32
:: mkdir build-win32 & pushd build-win32
:: ::cmake -DCMAKE_TOOLCHAIN_FILE=Modules\Windows32.cmake -G "Visual Studio 14" ..
:: cmake -DCMAKE_TOOLCHAIN_FILE=Modules\Windows32.cmake -G "Visual Studio 17 2022" -A x86 ..
:: cmake --build . --config Debug
:: cmake --build . --config Release
:: popd
:: endlocal


