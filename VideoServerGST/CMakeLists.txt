cmake_minimum_required(VERSION 2.8.3)
project(airsim_to_h264)

set(CMAKE_BUILD_TYPE Debug)

set(CMAKE_C_COMPILER "gcc")
set(CMAKE_CXX_COMPILER "g++")

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

include (FindPkgConfig)
pkg_check_modules(GSTREAMER REQUIRED gstreamer-1.0 gstreamer-app-1.0)
#find_package(GTK2 2.6 REQUIRED gtk)

include_directories(.
  ${GSTREAMER_INCLUDE_DIRS}
  ${GSTREAMER_BASE_INCLUDE_DIRS}
)

message("${CMAKE_PROGRAM_PREFIX_PATH}")

link_directories()

add_executable(testVideoServerGST testVideoServerGST.cpp VideoServerGST.cpp)

target_link_libraries(testVideoServerGST
    ${GSTREAMER_BASE_LIBRARIES}
    ${GSTREAMER_LIBRARIES}
)
#    ${GTK2_LIBRARIES}
