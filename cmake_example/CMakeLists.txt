# to build for the native host (works on windows too) call:
# for 32bit:
#  cmake -DCMAKE_TOOLCHAIN_FILE=Modules/Native32.cmake
# for 64bit:
#  cmake -DCMAKE_TOOLCHAIN_FILE=Modules/Native64.cmake
#
# to cross compile to Windows (from Mac/Lin/etc.) call:
# for 32bit:
#  cmake -DCMAKE_TOOLCHAIN_FILE=Modules/Windows32.cmake
# for 64bit:
#  cmake -DCMAKE_TOOLCHAIN_FILE=Modules/Windows64.cmake
#
# to natively build on Windows, but customize version of MSVC, call:
# for 32bit:
#  cmake -DCMAKE_TOOLCHAIN_FILE=Modules\Native32.cmake -G "Visual Studio 14"
#  cmake --build . --config Release        # build on command line without launching MSVC
# for 64bit:
#  cmake -DCMAKE_TOOLCHAIN_FILE=Modules\Native64.cmake -G "Visual Studio 14 Win64"
#  cmake --build . --config Release        # build on command line without launching MSVC
#
# More ways to cross compile:
#    You can let LLVM compile using defaults
#  cmake -DCMAKE_SYSTEM_NAME=LlvmWindowsCrossCompile
#    Or use CMAKE_SYSTEM_NAME to make your own toolchain file (see Modules/Windows??.cmake for ex)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/Modules")

SET(SRC ${CMAKE_CURRENT_SOURCE_DIR}/../src)
SET(ARCH ${CMAKE_LIBRARY_ARCHITECTURE})

CMAKE_MINIMUM_REQUIRED(VERSION 3.10.0 FATAL_ERROR)
SET(CMAKE_CXX_STANDARD 11)
SET(CMAKE_CXX_STANDARD_REQUIRED ON)
SET(CMAKE_CXX_EXTENSIONS OFF)
PROJECT(crosscompilewindows)


INCLUDE_DIRECTORIES(.)


# executable tests
ADD_EXECUTABLE(mainCPP-${ARCH} ${SRC}/main.cpp)
ADD_EXECUTABLE(mainC-${ARCH} ${SRC}/main.c)
if (WIN32)
   #set_property( TARGET mainCPP-${ARCH} APPEND_STRING PROPERTY LINK_LIBRARIES "libcmt" )
   #set_property( TARGET mainC-${ARCH} APPEND_STRING PROPERTY LINK_LIBRARIES "libcmt" )
   target_link_libraries( mainCPP-${ARCH} optimized  "libcmt" )
   target_link_libraries( mainCPP-${ARCH} debug  "libcmtd" )
   target_link_libraries( mainC-${ARCH} optimized  "libcmt" )
   target_link_libraries( mainC-${ARCH} debug  "libcmtd" )
endif()


# static library tests
add_library( lib-${ARCH} STATIC ${SRC}/lib.cpp )
ADD_EXECUTABLE(libmain-${ARCH} ${SRC}/libmain.cpp)
TARGET_LINK_LIBRARIES(libmain-${ARCH} lib-${ARCH})
if (WIN32)
   target_link_libraries( libmain-${ARCH} optimized  "libcmt" )
   target_link_libraries( libmain-${ARCH} debug  "libcmtd" )
   #set_property( TARGET libmain-${ARCH} APPEND_STRING PROPERTY LINK_LIBRARIES "libcmt" )
endif()

# dynamic link library tests
add_library( dll-${ARCH} SHARED ${SRC}/dll.cpp )
ADD_EXECUTABLE(dllmain-${ARCH} ${SRC}/dllmain.cpp)
TARGET_LINK_LIBRARIES(dllmain-${ARCH} dll-${ARCH})
if (WIN32)
   target_link_libraries( dllmain-${ARCH} optimized  "libcmt" )
   target_link_libraries( dllmain-${ARCH} debug  "libcmtd" )
   #set_property( TARGET dllmain-${ARCH} APPEND_STRING PROPERTY LINK_LIBRARIES "libcmt" )
endif()


# dynamic load library (plugin) tests
add_library( plugin-${ARCH} MODULE ${SRC}/dll.cpp )
ADD_EXECUTABLE(pluginmain-${ARCH} ${SRC}/plugin.cpp )
if (WIN32)
   target_link_libraries( pluginmain-${ARCH} optimized  "libcmt" )
   target_link_libraries( pluginmain-${ARCH} debug  "libcmtd" )
   #set_property( TARGET pluginmain-${ARCH} APPEND_STRING PROPERTY LINK_LIBRARIES "libcmt" )
endif()


