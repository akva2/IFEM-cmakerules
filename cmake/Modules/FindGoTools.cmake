IF(GoTools_INCLUDE_DIRS AND GoTools_LIBRARIES)
  SET(GoTools_FIND_QUIETLY TRUE)
ENDIF(GoTools_INCLUDE_DIRS AND GoTools_LIBRARIES)

FIND_PATH(GoTools_INCLUDE_DIRS
  NAMES GoTools/geometry/SplineSurface.h
  PATHS "$ENV{HOME}/include"
  "$ENV{HOME}/install/include"
  /sima/libs/GoTools/include
)

FIND_LIBRARY(GoTools_LIBRARIES
  NAMES GoToolsCore
  PATHS "$ENV{HOME}/lib"
  "$ENV{HOME}/install/lib"
  /sima/libs/GoTools/lib
  PATH_SUFFIXES GoTools
)

# Check for newer GoTools
EXECUTE_PROCESS(COMMAND cat "${GoTools_INCLUDE_DIRS}/GoTools/geometry/GoTools.h" OUTPUT_VARIABLE GOTOOLS_HEADER)
STRING(REGEX MATCH "GO_VERSION_MAJOR ([0-9]+)" GoTools_VERSION_MAJOR ${GOTOOLS_HEADER})
IF(NOT GoTools_VERSION_MAJOR)
  EXECUTE_PROCESS(COMMAND cat "${GoTools_INCLUDE_DIRS}/GoTools/geometry/GoTools_version.h" OUTPUT_VARIABLE GOTOOLS_HEADER)
  STRING(REGEX MATCH "GO_VERSION_MAJOR ([0-9]+)" GoTools_VERSION_MAJOR ${GOTOOLS_HEADER})
ENDIF(NOT GoTools_VERSION_MAJOR)
STRING(REGEX REPLACE "GO_VERSION_MAJOR ([0-9]+)" "\\1" GoTools_VERSION_MAJOR "${GoTools_VERSION_MAJOR}")
STRING(REGEX MATCH "GO_VERSION_MINOR ([0-9]+)" GoTools_VERSION_MINOR ${GOTOOLS_HEADER})
STRING(REGEX REPLACE "GO_VERSION_MINOR ([0-9]+)" "\\1" GoTools_VERSION_MINOR "${GoTools_VERSION_MINOR}")
STRING(REGEX MATCH "GO_VERSION_PATCH ([0-9]+)" GoTools_VERSION_PATCH ${GOTOOLS_HEADER})
STRING(REGEX REPLACE "GO_VERSION_PATCH ([0-9]+)" "\\1" GoTools_VERSION_PATCH "${GoTools_VERSION_PATCH}")

IF (GoTools_VERSION_MAJOR GREATER 2)
  INCLUDE(CheckCXXCompilerFlag)
  IF(CMAKE_CXX_COMPILER_ID MATCHES GNU)
  # check if compiler supports c++-0x
    CHECK_CXX_COMPILER_FLAG("-std=gnu++0x" HAVE_0x)
    IF(HAVE_0x)
      SET(GoTools_CXX_FLAGS "-std=gnu++0x")
    ELSE(HAVE_0x)
      MESSAGE(FATAL_ERROR "A compiler with c++-0x support is needed")
    ENDIF(HAVE_0x)
  ELSE(CMAKE_CXX_COMPILER_ID MATCHES GNU)
      MESSAGE(STATUS "Compiler is non-GNU, assuming GoTools was built with Boost")
      FIND_PACKAGE(Boost REQUIRED)
      SET(GoTools_CXX_FLAGS "-DUSE_BOOST=1")
      SET(GoTools_LIBRARIES ${GoTools_LIBRARIES} ${Boost_LIBRARIES})
      SET(GoTools_INCLUDE_DIRS ${GoTools_INCLUDE_DIRS} ${Boost_INCLUDE_DIR})
  ENDIF(CMAKE_CXX_COMPILER_ID MATCHES GNU)

  # Quirk test: GoTools r10221 changed function signature without bumping
  IF (GoTools_VERSION_MAJOR EQUAL 4 AND GoTools_VERSION_MINOR EQUAL 0
                                    AND GoTools_VERSION_PATCH EQUAL 1)
    INCLUDE(CheckFunctionExists)
    SET(CMAKE_REQUIRED_FLAGS ${GoTools_CXX_FLAGS})
    SET(CMAKE_REQUIRED_LIBRARIES ${GoTools_LIBRARIES})
      SET(CMAKE_REQUIRED_INCLUDES ${GoTools_INCLUDE_DIRS})
      CHECK_CXX_SOURCE_COMPILES("
                                 #include <GoTools/geometry/LoopUtils.h>
                              int main(void)
                              { 
                                std::vector<shared_ptr<Go::CurveOnSurface> > loop;
                                Go::LoopUtils::paramIsCCW(loop, 1.0, 1.0)
                              }
                             " GoTools_QUIRK_paramIsCCW)
    ENDIF (GoTools_VERSION_MAJOR EQUAL 4 AND GoTools_VERSION_MINOR EQUAL 0
                                         AND GoTools_VERSION_PATCH EQUAL 1)
ENDIF (GoTools_VERSION_MAJOR GREATER 2)

INCLUDE(FindPackageHandleStandardArgs)
IF(GoTools_LIBRARIES)
  find_package_handle_standard_args(GoTools DEFAULT_MSG
                                    GoTools_INCLUDE_DIRS GoTools_LIBRARIES)
ENDIF(GoTools_LIBRARIES)
