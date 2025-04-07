cmake_minimum_required(VERSION 3.16)

project(math_model_lab_2_vlad LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(math_model_lab_2_vlad main.cpp)

include(GNUInstallDirs)
install(TARGETS math_model_lab_2_vlad
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
