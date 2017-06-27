cmake_minimum_required(VERSION 2.8)
set(LIBNAME codec)
file(GLOB XCODEC "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp")
file(GLOB XCODE_HEADERS "${CMAKE_CURRENT_SOURCE_DIR}/*.h")
add_current_dir_libraries(${LIBNAME} ${XCODEC} ${XCODE_HEADERS})

