cmake_minimum_required(VERSION 3.5)

project(lab_1_mass LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable (lab_1_mass main.cpp)

install(TARGETS lab_1_mass
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})


