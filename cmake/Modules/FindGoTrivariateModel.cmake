# - Tries to find the GoTools TrivariateModel library
#
# Written by: jan.b.thomassen@sintef.no
#

# 'GoTools_BUILD_ALL' will be defined in the top-level CMakeLists.txt
# file if we are building all of GoTools in one project.
IF(GoTools_BUILD_ALL)
  # Header files
  SET(GoTrivariateModel_INCLUDE_DIRS ${GoTrivariateModel_SOURCE_DIR}/include
    CACHE PATH "Path to GoTools TrivariateModel header files")
  # Library
  SET(GoTrivariateModel_LIBRARIES GoTrivariateModel
    CACHE FILE "GoTools TrivariateModel library")
ENDIF(GoTools_BUILD_ALL)


# Find header files
FIND_PATH(GoTrivariateModel_INCLUDE_DIRS 
  "GoTools/trivariatemodel/VolumeModel.h"
  "$ENV{HOME}/include"
  "$ENV{HOME}/install/include"
  "C:/Program Files (x86)/GoTools/include"
  "$ENV{PROGRAMFILES}/SINTEF/GoTools/include"
)

# Find library
FIND_LIBRARY(GoTrivariateModel_LIBRARIES
  NAMES GoTrivariateModel
  PATHS "$ENV{HOME}/lib"
  "$ENV{HOME}/install/lib"
  "C:/Program Files (x86)/GoTools/lib"
  "$ENV{PROGRAMFILES}/SINTEF/GoTools/lib"
  PATH_SUFFIXES GoTools
)

# Check that we have found everything
SET(GoTrivariateModel_FOUND FALSE)
IF(GoTrivariateModel_INCLUDE_DIRS AND GoTrivariateModel_LIBRARIES)
  SET(GoTrivariateModel_FOUND TRUE)
ENDIF(GoTrivariateModel_INCLUDE_DIRS AND GoTrivariateModel_LIBRARIES)
