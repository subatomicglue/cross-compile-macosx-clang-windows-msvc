
# Toolchain for 64bit builds using auto-detected compiler
# - on non-windows platforms
#   cmake -DCMAKE_TOOLCHAIN_FILE=Modules/Native64.cmake
#
# - on Windows will generate a .sln project/solution for visual studio
#   call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64
#   cmake -DCMAKE_TOOLCHAIN_FILE=Modules\Native64.cmake -G "Visual Studio 14 Win64" ..

if (NOT WIN32)
   # you can build a hybrid Intel/AppleSilicon bundle using:   -arch arm64 -arch x86_64
   # to add that in, just use:    cmake -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64"

   #message( "We're going to build using native compiler for you" )
   set( CMAKE_C_FLAGS_INIT -m64 CACHE STRING "" FORCE)
   set( CMAKE_CXX_FLAGS_INIT -m64 CACHE STRING "" FORCE)
   set( CMAKE_EXE_LINKER_FLAGS_INIT -m64  CACHE STRING "" FORCE)
   set( CMAKE_MODULE_LINKER_FLAGS_INIT -m64  CACHE STRING "" FORCE)
   set( CMAKE_SHARED_LINKER_FLAGS_INIT -m64  CACHE STRING "" FORCE)
   set( CMAKE_ASM-ATT_FLAGS_INIT -m64 CACHE STRING "" FORCE)
   set( CMAKE_LIBRARY_ARCHITECTURE x64  CACHE STRING "" FORCE)
   set( ARCH x64  CACHE STRING "" FORCE)
else()
   #message( "Looks like you're actually on Windows 64bit with " ${CMAKE_GENERATOR} " sure I know how to do that" )
   if (NOT DEFINED CMAKE_GENERATOR)
      set( CMAKE_GENERATOR "Visual Studio 14 Win64" )
   endif()
   set( CMAKE_C_FLAGS_RELEASE "/MT" CACHE STRING "" FORCE)
   set( CMAKE_CXX_FLAGS_RELEASE "/MT" CACHE STRING "" FORCE)
   set( CMAKE_C_FLAGS_DEBUG "/MTd" CACHE STRING "" FORCE)
   set( CMAKE_CXX_FLAGS_DEBUG "/MTd" CACHE STRING "" FORCE)
   #SET( CMAKE_EXE_LINKER_FLAGS_INIT "/NODEFAULTLIB:MSVCRT" CACHE STRING "" FORCE)
   #SET( CMAKE_MODULE_LINKER_FLAGS_INIT "/NODEFAULTLIB:MSVCRT" CACHE STRING "" FORCE)
   #SET( CMAKE_SHARED_LINKER_FLAGS "/NODEFAULTLIB:MSVCRT" CACHE STRING "" FORCE)
   set( CMAKE_BUILD_TYPE Release )
   set( CMAKE_LIBRARY_ARCHITECTURE x64  CACHE STRING "" FORCE)
   set( ARCH x64  CACHE STRING "" FORCE)  # my custom flag
endif()

