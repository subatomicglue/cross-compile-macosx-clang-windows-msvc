
# to cross compile for Windows call:
#  cmake -DCMAKE_SYSTEM_NAME=LlvmWindowsCrossCompile
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/Modules")



CMAKE_MINIMUM_REQUIRED(VERSION 3.10.0 FATAL_ERROR)
SET(CMAKE_CXX_STANDARD 11)
SET(CMAKE_CXX_STANDARD_REQUIRED ON)
SET(CMAKE_CXX_EXTENSIONS OFF)
PROJECT(example)

INCLUDE_DIRECTORIES(.)
ADD_EXECUTABLE(example ../main.cpp)

#set_property( TARGET example APPEND_STRING PROPERTY LINK_FLAGS "-Tsomeflag1" )
#set_property( TARGET example APPEND_STRING PROPERTY CXXFLAGS "-Tsomeflag2" )
if (WIN32)
   set_property( TARGET example APPEND_STRING PROPERTY LINK_LIBRARIES "libcmt" )
endif()

add_library( example_lib ../lib.cpp )
ADD_EXECUTABLE(libmain ../libmain.cpp)
TARGET_LINK_LIBRARIES(libmain example_lib)


