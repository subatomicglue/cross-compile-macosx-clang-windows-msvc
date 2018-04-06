
# to cross compile for Windows call:
#  cmake -DCMAKE_SYSTEM_NAME=LlvmWindowsCrossCompile
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/Modules")

SET(SRC ${CMAKE_CURRENT_SOURCE_DIR}/../makefile_example)

CMAKE_MINIMUM_REQUIRED(VERSION 3.10.0 FATAL_ERROR)
SET(CMAKE_CXX_STANDARD 11)
SET(CMAKE_CXX_STANDARD_REQUIRED ON)
SET(CMAKE_CXX_EXTENSIONS OFF)
PROJECT(crosscompilewindows)

INCLUDE_DIRECTORIES(.)


# executable tests
ADD_EXECUTABLE(mainCPP-x64 ${SRC}/main.cpp)
ADD_EXECUTABLE(mainC-x64 ${SRC}/main.c)
ADD_EXECUTABLE(mainCPP-x32 ${SRC}/main.cpp)
ADD_EXECUTABLE(mainC-x32 ${SRC}/main.c)
if (WIN32)
   set_property( TARGET mainCPP-x64 APPEND_STRING PROPERTY LINK_LIBRARIES "libcmt" )
   set_property( TARGET mainC-x64 APPEND_STRING PROPERTY LINK_LIBRARIES "libcmt" )
   set_property( TARGET mainCPP-x32 APPEND_STRING PROPERTY LINK_LIBRARIES "libcmt" )
   set_property( TARGET mainC-x32 APPEND_STRING PROPERTY LINK_LIBRARIES "libcmt" )
endif()


# static library tests
add_library( lib-x64 ${SRC}/lib.cpp )
ADD_EXECUTABLE(libmain-x64 ${SRC}/libmain.cpp)
TARGET_LINK_LIBRARIES(libmain-x64 lib-x64)

add_library( lib-x86 ${SRC}/lib.cpp )
ADD_EXECUTABLE(libmain-x86 ${SRC}/libmain.cpp)
TARGET_LINK_LIBRARIES(libmain-x86 lib-x86)


# dynamic link library tests
add_library( dll-x64 ${SRC}/dll.cpp )
ADD_EXECUTABLE(dllmain-x64 ${SRC}/dllmain.cpp)
TARGET_LINK_LIBRARIES(dllmain-x64 dll-x64)

add_library( dll-x86 ${SRC}/dll.cpp )
ADD_EXECUTABLE(dllmain-x86 ${SRC}/dllmain.cpp)
TARGET_LINK_LIBRARIES(dllmain-x86 dll-x86)

if (WIN32)
   set_property( TARGET dllmain-x64 APPEND_STRING PROPERTY LINK_LIBRARIES "libcmt" )
   set_property( TARGET dllmain-x86 APPEND_STRING PROPERTY LINK_LIBRARIES "libcmt" )
endif()


# dynamic load library (plugin) tests
ADD_EXECUTABLE(plugin-x64 ${SRC}/plugin.cpp)
ADD_EXECUTABLE(plugin-x86 ${SRC}/plugin.cpp)
if (WIN32)
   set_property( TARGET plugin-x64 APPEND_STRING PROPERTY LINK_LIBRARIES "libcmt" )
   set_property( TARGET plugin-x86 APPEND_STRING PROPERTY LINK_LIBRARIES "libcmt" )
endif()

