cmake_minimum_required(VERSION 3.14)

project(GTestConfigTest)

# TODO
# cmake config to use library modules instead of absolute paths variables
# test against dynamic linkage
# cmake install is installing in both debug and release on either configuration
# get install directory working

enable_testing()
set(GTEST_ROOT "${CMAKE_SOURCE_DIR}/3rd_party/gtest")
find_package(GTest REQUIRED CONFIG PATHS "${CMAKE_SOURCE_DIR}")

add_executable(TestRunner main.cpp)
set(CMAKE_DEBUG_POSTFIX d)
set_target_properties(TestRunner PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})
# import librarys approach
target_link_libraries(TestRunner GTest::GTest GTest::Main)
# old approach
#target_include_directories(TestRunner PUBLIC ${GTEST_INCLUDE_DIRS})
#target_link_libraries(TestRunner PUBLIC ${GTEST_BOTH_LIBRARIES})

add_test(NAME TestRunner COMMAND TestRunner)


# note remove this if actually using as a config this is for easier debugging
set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/Install")

include(GNUInstallDirs)
install(TARGETS TestRunner
        RUNTIME DESTINATION Debug/${CMAKE_INSTALL_BINDIR}
        LIBRARY DESTINATION Debug/lib
        ARCHIVE DESTINATION Debug/lib/static
        CONFIGURATIONS Debug)

install(TARGETS TestRunner
        RUNTIME DESTINATION Release/bin
        LIBRARY DESTINATION Release/lib
        ARCHIVE DESTINATION Release/lib/static
        CONFIGURATIONS Release)

get_cmake_property(_variableNames VARIABLES)
list (SORT _variableNames)
list (FILTER _variableNames INCLUDE REGEX "^GTEST.*")
foreach (_variableName ${_variableNames})
    message(STATUS "${_variableName}=${${_variableName}}")
endforeach()