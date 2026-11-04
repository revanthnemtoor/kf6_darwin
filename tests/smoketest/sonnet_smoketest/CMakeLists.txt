cmake_minimum_required(VERSION 3.30)
project(sonnet_smoketest LANGUAGES CXX)

find_package(ECM 6.31.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs6)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(ECMMarkNonGuiExecutable)

find_package(Qt6 REQUIRED COMPONENTS Core)
find_package(KF6Sonnet 6.31.0 REQUIRED)

add_executable(sonnet_smoketest main.cpp)
ecm_mark_nongui_executable(sonnet_smoketest)
target_link_libraries(sonnet_smoketest PRIVATE Qt6::Core KF6::SonnetCore)

