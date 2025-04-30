cmake_minimum_required(VERSION 3.5)

project(lab_4 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(lab_4
    main.cpp
    genrandnumb.h
    genrandnumb.cpp
)

# Указываем CMake скопировать файл в папку сборки
configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/Y_e.txt
    ${CMAKE_CURRENT_BINARY_DIR}/Y_e.txt
    COPYONLY
)

configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/Y_e_original.txt
    ${CMAKE_CURRENT_BINARY_DIR}/Y_e_original.txt
    COPYONLY
)

install(TARGETS lab_4
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
