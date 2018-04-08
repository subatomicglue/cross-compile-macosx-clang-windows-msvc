# usage:
#   include("MSVCRuntime")
#   configure_msvc_runtime()
#
# you can choose:
#   cmake -DMSVC_RUNTIME=dynamic
#   cmake -DMSVC_RUNTIME=static
#
# or hard code it in CMakeLists.txt
#   set( MSVC_RUNTIME dynamic )
#   set( MSVC_RUNTIME static )

macro(configure_msvc_runtime)
   if(WIN32)
    # Default to statically-linked runtime.
    if("${MSVC_RUNTIME}" STREQUAL "")
      set(MSVC_RUNTIME "static")
    endif()
    # Set compiler options.
    set(variables
      CMAKE_C_FLAGS_DEBUG
      CMAKE_C_FLAGS_MINSIZEREL
      CMAKE_C_FLAGS_RELEASE
      CMAKE_C_FLAGS_RELWITHDEBINFO
      CMAKE_CXX_FLAGS_DEBUG
      CMAKE_CXX_FLAGS_MINSIZEREL
      CMAKE_CXX_FLAGS_RELEASE
      CMAKE_CXX_FLAGS_RELWITHDEBINFO
      CMAKE_C_FLAGS_DEBUG_INIT
      CMAKE_C_FLAGS_MINSIZEREL_INIT
      CMAKE_C_FLAGS_RELEASE_INIT
      CMAKE_C_FLAGS_RELWITHDEBINFO_INIT
      CMAKE_CXX_FLAGS_DEBUG_INIT
      CMAKE_CXX_FLAGS_MINSIZEREL_INIT
      CMAKE_CXX_FLAGS_RELEASE_INIT
      CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT
    )
    if(${MSVC_RUNTIME} STREQUAL "static")
      message(STATUS
        "MSVC -> forcing use of statically-linked runtime."
      )
      foreach(variable ${variables})
        if(${variable} MATCHES "/MD")
          string(REGEX REPLACE "/MD" "/MT" ${variable} "${${variable}}")
        endif()
      endforeach()
    else()
      message(STATUS
        "MSVC -> forcing use of dynamically-linked runtime."
      )
      foreach(variable ${variables})
        if(${variable} MATCHES "/MT")
          string(REGEX REPLACE "/MT" "/MD" ${variable} "${${variable}}")
        endif()
      endforeach()
    endif()
  endif()
endmacro()

