include(SelectLibraryConfigurations)


find_path(OPENTHREADS_INCLUDE_DIR OpenThreads/Thread
    HINTS
        ENV OPENTHREADS_INCLUDE_DIR
        ENV OPENTHREADS_DIR
        ENV OSG_INCLUDE_DIR
        ENV OSG_DIR
        ENV OSGDIR
        ENV OpenThreads_ROOT
        ENV OSG_ROOT
        ${OPENTHREADS_DIR}
        ${OSG_DIR}
    PATH_SUFFIXES include
)


find_library(OPENTHREADS_LIBRARY_RELEASE
    NAMES OpenThreads OpenThreadsWin32
    HINTS
        ENV OPENTHREADS_LIBRARY_DIR
        ENV OPENTHREADS_DIR
        ENV OSG_LIBRARY_DIR
        ENV OSG_DIR
        ENV OSGDIR
        ENV OpenThreads_ROOT
        ENV OSG_ROOT
        ${OPENTHREADS_DIR}
        ${OSG_DIR}
    PATH_SUFFIXES lib
)

find_library(OPENTHREADS_LIBRARY_DEBUG
    NAMES OpenThreadsd OpenThreadsWin32d
    HINTS
        ENV OPENTHREADS_DEBUG_LIBRARY_DIR
        ENV OPENTHREADS_LIBRARY_DIR
        ENV OPENTHREADS_DIR
        ENV OSG_LIBRARY_DIR
        ENV OSG_DIR
        ENV OSGDIR
        ENV OpenThreads_ROOT
        ENV OSG_ROOT
        ${OPENTHREADS_DIR}
        ${OSG_DIR}
    PATH_SUFFIXES lib
)

select_library_configurations(OPENTHREADS)

include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(OpenThreads DEFAULT_MSG
    OPENTHREADS_LIBRARY OPENTHREADS_INCLUDE_DIR)