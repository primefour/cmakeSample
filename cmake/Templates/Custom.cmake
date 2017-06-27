
# Set policy if policy is available
function(set_policy POL VAL)

    if(POLICY ${POL})
        cmake_policy(SET ${POL} ${VAL})
    endif()

endfunction(set_policy)


# Define function "source_group_by_path with three mandatory arguments (PARENT_PATH, REGEX, GROUP, ...)
# to group source files in folders (e.g. for MSVC solutions).
#
# Example:
# source_group_by_path("${CMAKE_CURRENT_SOURCE_DIR}/src" "\\\\.h$|\\\\.inl$|\\\\.cpp$|\\\\.c$|\\\\.ui$|\\\\.qrc$" "Source Files" ${sources})
function(source_group_by_path PARENT_PATH REGEX GROUP)

    foreach (FILENAME ${ARGN})
        
        get_filename_component(FILEPATH "${FILENAME}" REALPATH)
        file(RELATIVE_PATH FILEPATH ${PARENT_PATH} ${FILEPATH})
        get_filename_component(FILEPATH "${FILEPATH}" DIRECTORY)

        string(REPLACE "/" "\\" FILEPATH "${FILEPATH}")

	source_group("${GROUP}\\${FILEPATH}" REGULAR_EXPRESSION "${REGEX}" FILES ${FILENAME})

    endforeach()

endfunction(source_group_by_path)


# Function that extract entries matching a given regex from a list.
# ${OUTPUT} will store the list of matching filenames.
function(list_extract OUTPUT REGEX)

    foreach(FILENAME ${ARGN})
        if(${FILENAME} MATCHES "${REGEX}")
            list(APPEND ${OUTPUT} ${FILENAME})
        endif()
    endforeach()

    set(${OUTPUT} ${${OUTPUT}} PARENT_SCOPE)

endfunction(list_extract)


function(add_current_dir_libraries LIBNAME FILES INC)
    set(STATIC_NAME "${LIBNAME}_static")
    set(SHARED_NAME "${LIBNAME}_shared")

    add_library(${STATIC_NAME} STATIC ${FILES})
    add_library(${SHARED_NAME} SHARED ${FILES})

    SET_TARGET_PROPERTIES(${STATIC_NAME} PROPERTIES OUTPUT_NAME ${LIBNAME})
    SET_TARGET_PROPERTIES(${SHARED_NAME} PROPERTIES OUTPUT_NAME ${LIBNAME})

    SET_TARGET_PROPERTIES(${STATIC_NAME} PROPERTIES CLEAN_DIRECT_OUTPUT 1)
    SET_TARGET_PROPERTIES(${SHARED_NAME} PROPERTIES CLEAN_DIRECT_OUTPUT 1)

    INSTALL(FILES ${INC}  DESTINATION ${CMAKE_INSTALL_PREFIX}/include/)
    INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/lib${LIBNAME}.a DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/)
    INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/lib${LIBNAME}.so DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/)
endfunction(add_current_dir_libraries)

function(find_custom_library LIBNAME LIBPATHS HEADER LIBHEADERPATHS)
    string(TOUPPER ${LIBNAME} LVN)
    MESSAGE(STATUS "LVN IS ${LVN}")

    if (${LVN}_LIBRARY AND ${LVN}_INCLUDE_DIR)
        # in cache already
        set(${LVN}_FOUND TRUE)
    else (${LVN}_LIBRARY AND ${LVN}_INCLUDE_DIR)
        # find include path

        MESSAGE(STATUS ${LIBNAME}==> ${LIBPATHS} ==> ${HEADER} ==> ${LIBHEADERPATHS})

        find_path(${LVN}_INCLUDE_DIR NAMES ${HEADER} PATHS ${LIBHEADERPATHS})

        MESSAGE(STATUS "${LVN}_INCLUDE_DIR IS ${${LVN}_INCLUDE_DIR}")
        #find library
        find_library(${LVN}_STATIC_LIB NAMES lib${LIBNAME}.a PATHS ${LIBPATHS}) 
        find_library(${LVN}_SHARED_LIB NAMES lib${LIBNAME}.so PATHS ${LIBPATHS})
        #MESSAGE(STATUS "${LVN}_STATIC_LIB : ${${LVN}_STATIC_LIB}")
        #MESSAGE(STATUS "${LVN}_SHARED_LIB : ${${LVN}_SHARED_LIB}")
    

        if (${LVN}_STATIC_LIB OR ${LVN}_SHARED_LIB)
            set(${LVN}_FOUND TRUE)
        endif()

        if(${LVN}_STATIC_LIB)
            set(${LVN}_STATIC_FOUND TRUE)
            set(${LVN}_STATIC_LIBRARY ${${LVN}_STATIC_LIB})
            set(${LVN}_LIBRARY ${${LVN}_STATIC_LIB})
        endif()

        if(${LVN}_SHARED_LIB)
            set(${LVN}_SHARED_FOUND TRUE)
            set(${LVN}_SHARED_LIBRARY ${${LVN}_SHARED_LIB})
            if(NOT ${LVN}_LIBRARY)
                set(${LVN}_LIBRARY ${${LVN}_SHARED_LIB})
            endif()
        endif()

        if (${LVN}_FOUND)
            if (NOT ${LVN}_FIND_QUIETLY)
                message(STATUS "Found ${LVN} ${${LVN}_LIBRARY}, ${${LVN}_INCLUDE_DIR}")
            endif (NOT ${LVN}_FIND_QUIETLY)
        else (${LVN}_FOUND)
            if (${LVN}_FIND_REQUIRED)
                message(FATAL_ERROR "${LIBNAME} Could not find")
            endif (${LVN}_FIND_REQUIRED)
        endif (${LVN}_FOUND)
    endif (${LVN}_LIBRARY AND ${LVN}_INCLUDE_DIR)
endfunction(find_custom_library)
