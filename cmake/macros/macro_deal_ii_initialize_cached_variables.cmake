## ---------------------------------------------------------------------
##
## Copyright (C) 2012 - 2017 by the deal.II authors
##
## This file is part of the deal.II library.
##
## The deal.II library is free software; you can use it, redistribute
## it, and/or modify it under the terms of the GNU Lesser General
## Public License as published by the Free Software Foundation; either
## version 2.1 of the License, or (at your option) any later version.
## The full text of the license can be found in the file LICENSE.md at
## the top level directory of deal.II.
##
## ---------------------------------------------------------------------

#
# This file implements the DEAL_II_INITIALIZE_VARIABLES macro, which is
# part of the deal.II library.
#
# Usage:
#       DEAL_II_INITIALIZE_CACHED_VARIABLES()
#
# This sets some cached variables to the values used for compiling the
# deal.II library.
#
# This macro has to be called before PROJECT()!
#

MACRO(DEAL_II_INITIALIZE_CACHED_VARIABLES)

  IF(NOT DEAL_II_PROJECT_CONFIG_INCLUDED)
    MESSAGE(FATAL_ERROR
      "\nDEAL_II_INITIALIZE_CACHED_VARIABLES can only be called in external "
      "projects after the inclusion of deal.IIConfig.cmake. It is not "
      "intended for internal use.\n\n"
      )
  ENDIF()

  #
  # Set build type according to available libraries
  #
  IF(DEAL_II_BUILD_TYPE MATCHES "Debug")
    SET(CMAKE_BUILD_TYPE "Debug" CACHE STRING
      "Choose the type of build, options are: Debug, Release"
      )
  ELSE()
    SET(CMAKE_BUILD_TYPE "Release" CACHE STRING
      "Choose the type of build, options are: Debug, Release"
      )
  ENDIF()

  #
  # Reset build type if unsupported, i.e. if it is not Debug, Release, or
  # DebugRelease, or if the library doesn't support it
  #
  IF( NOT "${CMAKE_BUILD_TYPE}" MATCHES "^(Debug|Release|DebugRelease)$"
      OR NOT "${DEAL_II_BUILD_TYPE}" MATCHES "${CMAKE_BUILD_TYPE}" )

    IF("${DEAL_II_BUILD_TYPE}" STREQUAL "DebugRelease")
      SET(_new_build_type "Debug")
    ELSE()
      SET(_new_build_type "${DEAL_II_BUILD_TYPE}")
    ENDIF()

    MESSAGE(
"###
#
#  WARNING:
#
#  CMAKE_BUILD_TYPE \"${CMAKE_BUILD_TYPE}\" unsupported by current installation!
#  deal.II was configured with \"${DEAL_II_BUILD_TYPE}\".
#
#  CMAKE_BUILD_TYPE was forced to \"${_new_build_type}\".
#
###"
      )
    SET(CMAKE_BUILD_TYPE "${_new_build_type}" CACHE STRING
      "Choose the type of build, options are: Debug, Release"
      FORCE
      )

  ENDIF()


  SET(CMAKE_CXX_COMPILER ${DEAL_II_CXX_COMPILER} CACHE STRING
    "CXX Compiler.")
  SET(CMAKE_CXX_FLAGS "" CACHE STRING
    "Flags used by the compiler during all build types."
    )
  SET(CMAKE_CXX_FLAGS_DEBUG "" CACHE STRING
    "Flags used by the compiler during debug builds."
    )
  SET(CMAKE_CXX_FLAGS_RELEASE "" CACHE STRING
    "Flags used by the compiler during release builds."
    )


  IF(DEAL_II_WITH_CUDA)
    SET(CMAKE_CUDA_COMPILER ${DEAL_II_CUDA_COMPILER} CACHE STRING
      "CUDA Compiler.")
    SET(CMAKE_CUDA_HOST_COMPILER ${DEAL_II_CXX_COMPILER} CACHE STRING
      "CXX Compiler.")
    SET(CMAKE_CUDA_FLAGS "" CACHE STRING
      "Flags used by the compiler during all build types."
      )
    SET(CMAKE_CUDA_FLAGS_DEBUG "" CACHE STRING
      "Flags used by the compiler during debug builds."
      )
    SET(CMAKE_CUDA_FLAGS_RELEASE "" CACHE STRING
      "Flags used by the compiler during release builds."
      )
  ENDIF()

  MARK_AS_ADVANCED(CMAKE_INSTALL_PREFIX)

ENDMACRO()
