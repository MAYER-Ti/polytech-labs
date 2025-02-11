cmake_minimum_required(VERSION 3.5)

project(lab-4 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(lab-4
    shape.h
    shape.cpp
    point.h
    romb.h
    romb.cpp
    rectangle.h
    rectangle.cpp
    main.cpp

)

install(TARGETS lab-4
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
