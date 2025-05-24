cmake_minimum_required(VERSION 3.30)
project(lab_3)

set(CMAKE_CXX_STANDARD 20)

set(SOURCE
        main.cpp
        priorityQueue.cpp
        priorityQueue.h

)

add_executable(lab_3 ${SOURCE})
