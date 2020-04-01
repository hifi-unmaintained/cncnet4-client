cmake_minimum_required(VERSION 3.12.0)

if (NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    message(STATUS "No build type selected, default to Release")
    set(CMAKE_BUILD_TYPE "Release")
endif()

project(cncnet4-client VERSION 1.0.0 LANGUAGES C)

add_library(${CMAKE_PROJECT_NAME} SHARED
    res/dll.rc.in
    src/cncnet.c
    src/net.c
    src/cncnet.def
)

target_include_directories(${CMAKE_PROJECT_NAME} PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
)

target_link_libraries(${CMAKE_PROJECT_NAME}
	ws2_32 mswsock
)

set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES
	OUTPUT_NAME cncnet
)

# Define short commit hash.
find_package(Git)
execute_process(
    COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GITINFO_COMMIT_SHA1_SHORT
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

target_compile_definitions(${CMAKE_PROJECT_NAME} PUBLIC
	GIT_COMMIT_SHA1_SHORT="${GITINFO_COMMIT_SHA1_SHORT}"
)

# Disable deprecated API warnings for MSVC.
if(MSVC)
target_compile_definitions(${CMAKE_PROJECT_NAME} PUBLIC
	WIN32_LEAN_AND_MEAN=1
	_CRT_SECURE_NO_DEPRECATE=1
	_CRT_NONSTDC_NO_DEPRECATE=1
	_WINSOCK_DEPRECATED_NO_WARNINGS=1
	NOMINMAX=1
	)
endif()

# Set the main project to be the startup project in VS (default is ALL_BUILD).
if(MSVC)
set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
	PROPERTY VS_STARTUP_PROJECT ${CMAKE_PROJECT_NAME}
)
endif()
