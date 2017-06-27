if (FFMPEG_LIBRARIES AND FFMPEG_INCLUDE_DIR)
    # in cache already
    set(FFMPEG_FOUND TRUE)
else (FFMPEG_LIBRARIES AND FFMPEG_INCLUDE_DIR)

    set(FFMPEG_INCLUDE_OPTION_PATH /usr/include /usr/local/include /opt/local/include /sw/include ${CMAKE_CURRENT_SOURCE_DIR}/prebuild/ffmpeg/include/)
    set(FFMPEG_LIB_OPTION_PATH /usr/lib /usr/local/lib /opt/local/lib /sw/lib ${CMAKE_CURRENT_SOURCE_DIR}/prebuild/ffmpeg/lib/)

    # find include path
    find_path(FFMPEG_AVCODEC_INCLUDE_DIR NAMES libavcodec/avcodec.h PATHS ${FFMPEG_INCLUDE_OPTION_PATH})

    #find library
    find_library(FFMPEG_LIBAVDEVICE NAMES libavdevice.a PATHS ${FFMPEG_LIB_OPTION_PATH})
    find_library(FFMPEG_LIBAVFILTER NAMES libavfilter.a PATHS ${FFMPEG_LIB_OPTION_PATH})
    find_library(FFMPEG_LIBAVCODEC NAMES libavcodec.a PATHS ${FFMPEG_LIB_OPTION_PATH})
    find_library(FFMPEG_LIBAVFORMAT NAMES libavformat.a PATHS ${FFMPEG_LIB_OPTION_PATH})
    find_library(FFMPEG_LIBSWSCALE NAMES libswscale.a PATHS ${FFMPEG_LIB_OPTION_PATH})
    find_library(FFMPEG_LIBSWRESAMPLE NAMES libswresample.a PATHS ${FFMPEG_LIB_OPTION_PATH})
    find_library(FFMPEG_LIBAVUTIL NAMES libavutil.a PATHS ${FFMPEG_LIB_OPTION_PATH})

    find_library(FFMPEG_SHARED_LIBAVDEVICE NAMES libavdevice.so PATHS ${FFMPEG_LIB_OPTION_PATH})
    find_library(FFMPEG_SHARED_LIBAVFILTER NAMES libavfilter.so PATHS ${FFMPEG_LIB_OPTION_PATH})
    find_library(FFMPEG_SHARED_LIBAVCODEC NAMES libavcodec.so PATHS ${FFMPEG_LIB_OPTION_PATH})
    find_library(FFMPEG_SHARED_LIBAVFORMAT NAMES libavformat.so PATHS ${FFMPEG_LIB_OPTION_PATH})
    find_library(FFMPEG_SHARED_LIBSWSCALE NAMES libswscale.so PATHS ${FFMPEG_LIB_OPTION_PATH})
    find_library(FFMPEG_SHARED_LIBSWRESAMPLE NAMES libswresample.so PATHS ${FFMPEG_LIB_OPTION_PATH})
    find_library(FFMPEG_SHARED_LIBAVUTIL NAMES libavutil.so PATHS ${FFMPEG_LIB_OPTION_PATH})

    

    if (FFMPEG_LIBAVCODEC AND FFMPEG_LIBAVFORMAT)
        set(FFMPEG_FOUND TRUE)
    endif()

    if (FFMPEG_FOUND)
        set(FFMPEG_INCLUDE_DIR ${FFMPEG_AVCODEC_INCLUDE_DIR})
        set(FFMPEG_LIBRARIES
            ${FFMPEG_LIBAVDEVICE}
            ${FFMPEG_LIBAVFILTER}
            ${FFMPEG_LIBAVCODEC}
            ${FFMPEG_LIBAVFORMAT}
            ${FFMPEG_LIBSWSCALE}
            ${FFMPEG_LIBSWRESAMPLE}
            ${FFMPEG_LIBAVUTIL}
        )
        set(FFMPEG_SHARED_LIBRARIES
            ${FFMPEG_SHARED_LIBAVDEVICE}
            ${FFMPEG_SHARED_LIBAVFILTER}
            ${FFMPEG_SHARED_LIBAVCODEC}
            ${FFMPEG_SHARED_LIBAVFORMAT}
            ${FFMPEG_SHARED_LIBSWSCALE}
            ${FFMPEG_SHARED_LIBSWRESAMPLE}
            ${FFMPEG_SHARED_LIBAVUTIL}
        )
    endif (FFMPEG_FOUND)

    if (FFMPEG_FOUND)
        if (NOT FFMPEG_FIND_QUIETLY)
            message(STATUS "Found FFMPEG or Libav: ${FFMPEG_LIBRARIES}, ${FFMPEG_INCLUDE_DIR}")
        endif (NOT FFMPEG_FIND_QUIETLY)
    else (FFMPEG_FOUND)
        if (FFMPEG_FIND_REQUIRED)
            message(FATAL_ERROR "Could not find libavcodec or libavformat or libavutil")
        endif (FFMPEG_FIND_REQUIRED)
    endif (FFMPEG_FOUND)

endif (FFMPEG_LIBRARIES AND FFMPEG_INCLUDE_DIR)
