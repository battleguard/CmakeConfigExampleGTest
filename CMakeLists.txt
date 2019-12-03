cmake_minimum_required(VERSION 3.14)

enable_testing()
set(GTEST_ROOT "${CMAKE_SOURCE_DIR}/3rd_party/gtest")
find_package(GTest REQUIRED CONFIG PATHS "${CMAKE_SOURCE_DIR}")

add_executable(TestRunner main.cpp)
target_link_libraries(TestRunner GTest::GTest GTest::Main)
add_test(NAME TestRunner COMMAND TestRunner)

get_cmake_property(_variableNames VARIABLES)
list (SORT _variableNames)
list (FILTER _variableNames INCLUDE REGEX "^GTEST.*")
foreach (_variableName ${_variableNames})
    message(STATUS "${_variableName}=${${_variableName}}")
endforeach()