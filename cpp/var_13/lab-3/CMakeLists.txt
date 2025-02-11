cmake_minimum_required(VERSION 3.5)

project(lab-3 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(lab-3
    main.cpp
    polinom.cpp
    polinom.h
)

install(TARGETS lab-3
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
