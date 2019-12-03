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

__gtest_find_library(GTEST_LIBRARY_RELEASE      gtest)
__gtest_find_library(GTEST_LIBRARY_DEBUG        gtestd)
__gtest_find_library(GTEST_MAIN_LIBRARY_RELEASE gtest_main)
__gtest_find_library(GTEST_MAIN_LIBRARY_DEBUG   gtest_maind)

select_library_configurations(GTEST)
select_library_configurations(GTEST_MAIN)

include(FindPackageHandleStandardArgs)
#find_package_handle_standard_args(OpenThreads DEFAULT_MSG
#    OPENTHREADS_LIBRARY OPENTHREADS_INCLUDE_DIR)

find_package_handle_standard_args(GTest DEFAULT_MSG
    GTEST_LIBRARY GTEST_INCLUDE_DIR)