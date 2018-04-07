
# to cross compile for Windows call:
#  cmake -DCMAKE_SYSTEM_NAME=LlvmWindowsCrossCompile
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/Modules")

SET(SRC ${CMAKE_CURRENT_SOURCE_DIR}/../makefile_example)
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
   set_property( TARGET mainCPP-${ARCH} APPEND_STRING PROPERTY LINK_LIBRARIES "libcmt" )
   set_property( TARGET mainC-${ARCH} APPEND_STRING PROPERTY LINK_LIBRARIES "libcmt" )
endif()


# static library tests
add_library( lib-${ARCH} STATIC ${SRC}/lib.cpp )
ADD_EXECUTABLE(libmain-${ARCH} ${SRC}/libmain.cpp)
TARGET_LINK_LIBRARIES(libmain-${ARCH} lib-${ARCH})


# dynamic link library tests
add_library( dll-${ARCH} SHARED ${SRC}/dll.cpp )
ADD_EXECUTABLE(dllmain-${ARCH} ${SRC}/dllmain.cpp)
TARGET_LINK_LIBRARIES(dllmain-${ARCH} dll-${ARCH})

if (WIN32)
   set_property( TARGET dllmain-${ARCH} APPEND_STRING PROPERTY LINK_LIBRARIES "libcmt" )
endif()


# dynamic load library (plugin) tests
add_library( plugin-${ARCH} MODULE ${SRC}/dll.cpp )
ADD_EXECUTABLE(pluginmain-${ARCH} ${SRC}/plugin.cpp )
if (WIN32)
   set_property( TARGET pluginmain-${ARCH} APPEND_STRING PROPERTY LINK_LIBRARIES "libcmt" )
endif()


