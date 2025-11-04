cmake_minimum_required(VERSION 3.14)
project(iatetris LANGUAGES CXX)

set(BINARY_NAME "iatetris")

cmake_policy(SET CMP0063 NEW)

set(CMAKE_INSTALL_RPATH "$ORIGIN/lib")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_FLAGS "/utf-8")

get_filename_component(PROJECT_DIR "${CMAKE_CURRENT_SOURCE_DIR}" ABSOLUTE)

set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}")

add_subdirectory(${FLUTTER_MANAGED_DIR} flutter)

add_subdirectory("runner")

install(TARGETS ${BINARY_NAME} DESTINATION "$<CONFIG>"
  COMPONENT Runtime)