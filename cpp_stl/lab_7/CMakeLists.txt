cmake_minimum_required(VERSION 3.16)

project(lab-7 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(lab-7
    main.cpp
    statisticcollector.cpp
    statisticcollector.h
)

include(GNUInstallDirs)
install(TARGETS lab-7
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
