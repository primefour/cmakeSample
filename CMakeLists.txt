cmake_minimum_required(VERSION 2.8)
PROJECT(sample)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Templates/")
include(${CMAKE_SOURCE_DIR}/cmake/Templates/Custom.cmake)

FIND_PACKAGE(Qt4 REQUIRED QtCore QtGui)
set(CMAKE_AUTOMOC ON)
INCLUDE(${QT_USE_FILE})


#add current directory header file
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR})
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})

#find ffmpeg libraries
find_package(FFMPEG REQUIRED)

#set(AVCODEC_INC_OPTION_PATH /usr/include /usr/local/include /opt/local/include /sw/include ${CMAKE_CURRENT_SOURCE_DIR}/prebuild/ffmpeg/include/)
#set(AVCODEC_LIB_OPTION_PATH /usr/lib /usr/local/lib /opt/local/lib /sw/lib ${CMAKE_CURRENT_SOURCE_DIR}/prebuild/ffmpeg/lib/)
#set(AVCODEC_HEADER libavcodec/avcodec.h)
#find_custom_library(avcodec "${AVCODEC_LIB_OPTION_PATH}" ${AVCODEC_HEADER} "${AVCODEC_INC_OPTION_PATH}")

INCLUDE_DIRECTORIES(${FFMPEG_INCLUDE_DIR})

#add codec header
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR}/codec)
#add codec cmake project
ADD_SUBDIRECTORY(codec)


#find project source file
file(GLOB XSOURCE "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp")

#add execute target
ADD_EXECUTABLE(sample ${XSOURCE})

#add dependence
add_dependencies(sample codec_static)
add_dependencies(sample codec_shared)

TARGET_LINK_LIBRARIES(sample ${QT_LIBRARIES} ${CMAKE_CURRENT_BINARY_DIR}/codec/libcodec.a ${FFMPEG_LIBRARIES})

INSTALL(FILES ${CMAKE_CURRENT_SOURCE_DIR}/one_frame_sample.yuv DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
INSTALL(TARGETS sample RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
