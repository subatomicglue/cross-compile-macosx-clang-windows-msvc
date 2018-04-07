
# Toolchain for 32bit builds using auto-detected compiler
# - on non-windows platforms
#   cmake -DCMAKE_TOOLCHAIN_FILE=Modules/Native32.cmake
#
# - on Windows will generate a .sln project/solution for visual studio
#   call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86
#   cmake -DCMAKE_TOOLCHAIN_FILE=Modules\Native32.cmake -G "Visual Studio 14" ..

if (NOT WIN32)
   #message( "We're going to build using native compiler for you" )
   set( CMAKE_C_FLAGS_INIT -m32 CACHE STRING "" FORCE)
   set( CMAKE_CXX_FLAGS_INIT -m32 CACHE STRING "" FORCE)
   set( CMAKE_EXE_LINKER_FLAGS_INIT -m32  CACHE STRING "" FORCE)
   set( CMAKE_MODULE_LINKER_FLAGS_INIT -m32  CACHE STRING "" FORCE)
   set( CMAKE_SHARED_LINKER_FLAGS_INIT -m32  CACHE STRING "" FORCE)
   set( CMAKE_ASM-ATT_FLAGS_INIT -m32 CACHE STRING "" FORCE)
   set( CMAKE_LIBRARY_ARCHITECTURE x86  CACHE STRING "" FORCE)
   set( ARCH x86  CACHE STRING "" FORCE)
else()
   #message( "We're going to build using visual studio for you" )
   if (NOT DEFINED CMAKE_GENERATOR)
      set( CMAKE_GENERATOR "Visual Studio 14" )
   endif()
   set( CMAKE_C_FLAGS_RELEASE "/MT" CACHE STRING "" FORCE)
   set( CMAKE_CXX_FLAGS_RELEASE "/MT" CACHE STRING "" FORCE)
   set( CMAKE_C_FLAGS_DEBUG "/MTd" CACHE STRING "" FORCE)
   set( CMAKE_CXX_FLAGS_DEBUG "/MTd" CACHE STRING "" FORCE)
   #SET( CMAKE_EXE_LINKER_FLAGS_INIT "/NODEFAULTLIB:MSVCRT" CACHE STRING "" FORCE)
   #SET( CMAKE_MODULE_LINKER_FLAGS_INIT "/NODEFAULTLIB:MSVCRT" CACHE STRING "" FORCE)
   #SET( CMAKE_SHARED_LINKER_FLAGS "/NODEFAULTLIB:MSVCRT" CACHE STRING "" FORCE)
   set( CMAKE_BUILD_TYPE Release )
   set( CMAKE_LIBRARY_ARCHITECTURE x86  CACHE STRING "" FORCE)
   set( ARCH x86  CACHE STRING "" FORCE)  # my custom flag
endif()

