FIND_PATH(
  PETSC_INCLUDE_DIR
  NAMES petsc.h
  PATHS /usr/include/petsc/
  $ENV{PETSC_DIR}/include
  )
FIND_PATH(
  PETSCCONF_INCLUDE_DIR
  NAMES petscconf.h
  PATHS /usr/include/petsc/ 
  $ENV{PETSC_DIR}/$ENV{PETSC_ARCH}/include
  )

IF(NOT PETSC_INCLUDE_DIR OR NOT PETSCCONF_INCLUDE_DIR)
  MESSAGE(FATAL_ERROR "PETSc not found")
ENDIF()

# Check for version
IF (PETSC_INCLUDE_DIR)
  EXECUTE_PROCESS(COMMAND cat "${PETSC_INCLUDE_DIR}/petscversion.h" OUTPUT_VARIABLE PETSC_HEADER)
  STRING(REGEX MATCH "PETSC_VERSION_RELEASE *([0-9]+)" PETSC_VERSION_RELEASE ${PETSC_HEADER})
  STRING(REGEX REPLACE "PETSC_VERSION_RELEASE *([0-9]+)" "\\1" PETSC_VERSION_RELEASE "${PETSC_VERSION_RELEASE}")
  STRING(REGEX MATCH "PETSC_VERSION_MAJOR *([0-9]+)" PETSC_VERSION_MAJOR ${PETSC_HEADER})
  STRING(REGEX REPLACE "PETSC_VERSION_MAJOR *([0-9]+)" "\\1" PETSC_VERSION_MAJOR "${PETSC_VERSION_MAJOR}")
  STRING(REGEX MATCH "PETSC_VERSION_MINOR *([0-9]+)" PETSC_VERSION_MINOR ${PETSC_HEADER})
  STRING(REGEX REPLACE "PETSC_VERSION_MINOR *([0-9]+)" "\\1" PETSC_VERSION_MINOR "${PETSC_VERSION_MINOR}")
  STRING(REGEX MATCH "PETSC_VERSION_PATCH *([0-9]+)" PETSC_VERSION_PATCH ${PETSC_HEADER})
  STRING(REGEX REPLACE "PETSC_VERSION_PATCH *([0-9]+)" "\\1" PETSC_VERSION_PATCH "${PETSC_VERSION_PATCH}")
ENDIF(PETSC_INCLUDE_DIR)

# Fix me when required
IF (PETSC_VERSION_MAJOR EQUAL 3 AND PETSC_VERSION_MINOR GREATER 2)
  IF(PETSC_INCLUDE_DIR AND PETSCCONF_INCLUDE_DIR)
    INCLUDE($ENV{PETSC_DIR}/$ENV{PETSC_ARCH}/conf/PETScConfig.cmake)
    FIND_LIBRARY(PETSC_LIB_PETSC     petsc  HINTS $ENV{PETSC_DIR}/$ENV{PETSC_ARCH}/lib)
    SET(PETSC_LIBRARIES ${PETSC_LIB_PETSC} ${PETSC_PACKAGE_LIBS})
    SET(PETSC_INCLUDES ${PETSC_INCLUDE_DIR} ${PETSCCONF_INCLUDE_DIR} ${PETSC_PACKAGE_INCLUDES})
    MARK_AS_ADVANCED(PETSC_LIBRARIES PETSC_INCLUDES)
  ENDIF(PETSC_INCLUDE_DIR AND PETSCCONF_INCLUDE_DIR)
ELSE(PETSC_VERSION_MAJOR EQUAL 3 AND PETSC_VERSION_MINOR GREATER 2)
  MESSAGE(FATAL_ERROR "PETSc >= 3.3 required")
ENDIF(PETSC_VERSION_MAJOR EQUAL 3 AND PETSC_VERSION_MINOR GREATER 2)

INCLUDE(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PETSC DEFAULT_MSG
                                  PETSC_INCLUDES PETSC_LIBRARIES)
