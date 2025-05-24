cmake_minimum_required(VERSION 3.16)

project(GenRandNumb LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(GenRandNumb main.cpp
    normaldistributiongenerator.h normaldistributiongenerator.cpp)

include(GNUInstallDirs)
install(TARGETS GenRandNumb
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
