cmake_minimum_required(VERSION 3.16)

project(lab_5 LANGUAGES CXX)



set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(OpenCV REQUIRED)

# Включение заголовочных файлов OpenCV
include_directories(${OpenCV_INCLUDE_DIRS})

add_executable(lab_5 main.cpp)

target_link_libraries( lab_5 ${OpenCV_LIBS})

include(GNUInstallDirs)
install(TARGETS lab_5
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
