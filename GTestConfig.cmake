include(SelectLibraryConfigurations)

#GTEST_FOUND``
#GTEST_INCLUDE_DIRS
# examples used FindOpenThreads.cmake, FindGTest.cmake

find_path(GTEST_INCLUDE_DIR gtest/gtest.h
    HINTS
        ENV GTEST_ROOT
        ENV GTEST_DIR
        ${GTEST_ROOT}
        ${GTEST_DIR}
    PATH_SUFFIXES include
)
mark_as_advanced(GTEST_INCLUDE_DIR)



function(__gtest_append_debugs _endvar _library)
    if(${_library} AND ${_library}_DEBUG)
        set(_output optimized ${${_library}} debug ${${_library}_DEBUG})
    else()
        set(_output ${${_library}})
    endif()
    set(${_endvar} ${_output} PARENT_SCOPE)
endfunction()

function(__gtest_find_library _name)
    find_library(${_name}
        NAMES ${ARGN}
        HINTS
           ENV GTEST_ROOT
           ENV GTEST_DIR
           ${GTEST_ROOT}
           ${GTEST_DIR}
        PATH_SUFFIXES lib
    )
    mark_as_advanced(${_name})
endfunction()

macro(__gtest_determine_windows_library_type _var)
    if(EXISTS "${${_var}}")
        file(TO_NATIVE_PATH "${${_var}}" _lib_path)
        get_filename_component(_name "${${_var}}" NAME_WE)
        file(STRINGS "${${_var}}" _match REGEX "${_name}\\.dll" LIMIT_COUNT 1)
        if(NOT _match STREQUAL "")
            set(${_var}_TYPE SHARED PARENT_SCOPE)
        else()
            set(${_var}_TYPE UNKNOWN PARENT_SCOPE)
        endif()
        return()
    endif()
endmacro()

function(__gtest_determine_library_type _var)
    if(WIN32)
        # For now, at least, only Windows really needs to know the library type
        __gtest_determine_windows_library_type(${_var})
        __gtest_determine_windows_library_type(${_var}_RELEASE)
        __gtest_determine_windows_library_type(${_var}_DEBUG)
    endif()
    # If we get here, no determination was made from the above checks
    set(${_var}_TYPE UNKNOWN PARENT_SCOPE)
endfunction()

function(__gtest_import_library _target _var _config)
    if(_config)
        set(_config_suffix "_${_config}")
    else()
        set(_config_suffix "")
    endif()

    set(_lib "${${_var}${_config_suffix}}")
    if(EXISTS "${_lib}")
        if(_config)
            set_property(TARGET ${_target} APPEND PROPERTY
                IMPORTED_CONFIGURATIONS ${_config})
        endif()
        set_target_properties(${_target} PROPERTIES
            IMPORTED_LINK_INTERFACE_LANGUAGES${_config_suffix} "CXX")
        if(WIN32 AND ${_var}_TYPE STREQUAL SHARED)
            set_target_properties(${_target} PROPERTIES
                IMPORTED_IMPLIB${_config_suffix} "${_lib}")
        else()
            set_target_properties(${_target} PROPERTIES
                IMPORTED_LOCATION${_config_suffix} "${_lib}")
        endif()
    endif()
endfunction()

__gtest_find_library(GTEST_LIBRARY            gtest)
__gtest_find_library(GTEST_LIBRARY_DEBUG      gtestd)
__gtest_find_library(GTEST_MAIN_LIBRARY       gtest_main)
__gtest_find_library(GTEST_MAIN_LIBRARY_DEBUG gtest_maind)

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(GTest DEFAULT_MSG
    GTEST_LIBRARY GTEST_INCLUDE_DIR GTEST_MAIN_LIBRARY)

if(GTEST_FOUND)
    set(GTEST_INCLUDE_DIRS ${GTEST_INCLUDE_DIR})
    __gtest_append_debugs(GTEST_LIBRARIES      GTEST_LIBRARY)
    __gtest_append_debugs(GTEST_MAIN_LIBRARIES GTEST_MAIN_LIBRARY)
    set(GTEST_BOTH_LIBRARIES ${GTEST_LIBRARIES} ${GTEST_MAIN_LIBRARIES})

    find_package(Threads QUIET)

    if(NOT TARGET GTest::GTest)
        __gtest_determine_library_type(GTEST_LIBRARY)
        add_library(GTest::GTest ${GTEST_LIBRARY_TYPE} IMPORTED)
        if(TARGET Threads::Threads)
            set_target_properties(GTest::GTest PROPERTIES
                INTERFACE_LINK_LIBRARIES Threads::Threads)
        endif()
        if(GTEST_LIBRARY_TYPE STREQUAL "SHARED")
            set_target_properties(GTest::GTest PROPERTIES
                INTERFACE_COMPILE_DEFINITIONS "GTEST_LINKED_AS_SHARED_LIBRARY=1")
        endif()
        if(GTEST_INCLUDE_DIRS)
            set_target_properties(GTest::GTest PROPERTIES
                INTERFACE_INCLUDE_DIRECTORIES "${GTEST_INCLUDE_DIRS}")
        endif()
        __gtest_import_library(GTest::GTest GTEST_LIBRARY "")
        __gtest_import_library(GTest::GTest GTEST_LIBRARY "RELEASE")
        __gtest_import_library(GTest::GTest GTEST_LIBRARY "DEBUG")
    endif()
    if(NOT TARGET GTest::Main)
        __gtest_determine_library_type(GTEST_MAIN_LIBRARY)
        add_library(GTest::Main ${GTEST_MAIN_LIBRARY_TYPE} IMPORTED)
        set_target_properties(GTest::Main PROPERTIES
            INTERFACE_LINK_LIBRARIES "GTest::GTest")
        __gtest_import_library(GTest::Main GTEST_MAIN_LIBRARY "")
        __gtest_import_library(GTest::Main GTEST_MAIN_LIBRARY "RELEASE")
        __gtest_import_library(GTest::Main GTEST_MAIN_LIBRARY "DEBUG")
    endif()
endif()
