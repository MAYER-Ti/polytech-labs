cmake_minimum_required(VERSION 3.16)

project(lab_3 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(OpenMP REQUIRED)

add_executable(lab_3 main.cpp)

target_link_libraries(lab_3 OpenMP::OpenMP_CXX)

include(GNUInstallDirs)
install(TARGETS lab_3
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
