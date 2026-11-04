cmake_minimum_required(VERSION 3.20)
project(kservice_smoketest LANGUAGES CXX)

find_package(ECM 6.31.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(ECMMarkNonGuiExecutable)
include(KDECompilerSettings NO_POLICY_SCOPE)

find_package(Qt6 REQUIRED COMPONENTS Core)
find_package(KF6Service 6.31.0 REQUIRED)

add_executable(kservice_smoketest main.cpp)
ecm_mark_nongui_executable(kservice_smoketest)
target_link_libraries(kservice_smoketest PRIVATE Qt6::Core KF6::Service)

