cmake_minimum_required(VERSION 2.8)
PROJECT(sample)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Templates/")
include(${CMAKE_SOURCE_DIR}/cmake/Templates/Custom.cmake)

set(WITH_QT 5)

if(WITH_QT EQUAL 4)
    FIND_PACKAGE(Qt4 REQUIRED QtCore QtGui)
    INCLUDE(${QT_USE_FILE})
else(WITH_QT EQUAL 4)
    set(CMAKE_PREFIX_PATH  ${CMAKE_PREFIX_PATH} "/home/crazyhorse/Qt5.9.0/5.9/gcc_64/lib/cmake/Qt5/")
    find_package(Qt5 REQUIRED Core Gui Widgets)
    get_target_property(QtCore_location Qt5::Core LOCATION)
    get_target_property(QtGui_location Qt5::Gui LOCATION)
    get_target_property(QtWidgets_location Qt5::Widgets LOCATION)
    set(QT_LIBRARIES ${QtCore_location} ${QtGui_location} ${QtWidgets_location}) 
    #MESSAGE(STATUS "QtCore_location  = ${QtCore_location}")
    #MESSAGE(STATUS "Qt5<Module>_LIBRARIES  = ${Qt5Core_LIBRARIES}")
    MESSAGE(STATUS "QT_LIBRARIES  = ${QT_LIBRARIES}")
    INCLUDE_DIRECTORIES(${Qt5Gui_INCLUDE_DIRS})
    MESSAGE(STATUS "Qt5Gui_INCLUDE_DIRS= ${Qt5Gui_INCLUDE_DIRS}")
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++11 -fPIC -DQT5_LIBRARY")
endif()

set(CMAKE_AUTOMOC ON)


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
ADD_SUBDIRECTORY(jni)


#find project source file
file(GLOB XSOURCE "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp")
#add execute target
ADD_EXECUTABLE(sample ${XSOURCE})

#add dependence
add_dependencies(sample codec_static)
add_dependencies(sample codec_shared)
add_dependencies(sample jni_codec_static)
add_dependencies(sample jni_codec_shared)

TARGET_LINK_LIBRARIES(sample ${QT_LIBRARIES} ${CMAKE_CURRENT_BINARY_DIR}/codec/libcodec.a ${FFMPEG_LIBRARIES})

INSTALL(FILES ${CMAKE_CURRENT_SOURCE_DIR}/one_frame_sample.yuv DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
INSTALL(TARGETS sample RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
