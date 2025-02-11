cmake_minimum_required(VERSION 3.5)

project(lab-2 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(lab-2
    main.cpp

    haveEqualsChar.h

    haveEqualsChar.cpp
)

install(TARGETS lab-2
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
