cmake_minimum_required(VERSION 3.10)
project(iatetris LANGUAGES CXX)

set(BINARY_NAME "iatetris")
set(APPLICATION_ID "com.example.iatetris")

cmake_policy(SET CMP0063 NEW)

set(CMAKE_INSTALL_RPATH "$ORIGIN/lib")

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_FLAGS_RELEASE "-DNDEBUG")

find_program(FLUTTER_TOOL flutter REQUIRED)

get_filename_component(PROJECT_DIR "${CMAKE_CURRENT_SOURCE_DIR}" ABSOLUTE)
set(FLUTTER_ROOT "/usr/local/flutter" CACHE PATH "Flutter SDK")
list(APPEND FLUTTER_TOOL_ARGS
     "build" "bundle"
     "--local-engine-src-path=${FLUTTER_ENGINE_SRC_PATH}"
     "--local-engine=${FLUTTER_ENGINE}"
     "--local-engine-host=${FLUTTER_ENGINE_HOST}"
)

add_custom_target(flutter_assemble ALL
  COMMAND ${FLUTTER_TOOL} ${FLUTTER_TOOL_ARGS}
  WORKING_DIRECTORY ${PROJECT_DIR}
)

set(FLUTTER_LIB "${PROJECT_DIR}/build/flutter_assets")
set(FLUTTER_LIB_NAME "flutter_linux_gtk")

include_directories(${FLUTTER_ROOT}/shell/platform/common/cpp)
include_directories(${FLUTTER_ROOT}/shell/platform/common/client_wrapper/include)
include_directories(${FLUTTER_ROOT}/shell/platform/linux)

add_executable(${BINARY_NAME}
  "main.cc"
  "my_application.cc"
  "${FLUTTER_ROOT}/shell/platform/common/cpp/client_wrapper/core_implementations.cc"
  "${FLUTTER_ROOT}/shell/platform/common/cpp/client_wrapper/standard_method_codec.cc"
  "${FLUTTER_ROOT}/shell/platform/common/cpp/client_wrapper/plugin_registrar.cc"
  "${FLUTTER_ROOT}/shell/platform/common/cpp/client_wrapper/flutter_engine.cc"
  "${FLUTTER_ROOT}/shell/platform/common/cpp/client_wrapper/flutter_view_controller.cc"
)

target_link_libraries(${BINARY_NAME} PRIVATE ${FLUTTER_LIB_NAME})
target_link_libraries(${BINARY_NAME} PRIVATE gtk+-3.0)

add_dependencies(${BINARY_NAME} flutter_assemble)

set_target_properties(${BINARY_NAME} PROPERTIES
  INSTALL_RPATH "\$ORIGIN/lib"
)