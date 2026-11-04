cmake_minimum_required(VERSION 3.20)
project(knotifications_smoketest LANGUAGES CXX)

find_package(ECM 6.31.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(ECMMarkNonGuiExecutable)
include(KDECompilerSettings NO_POLICY_SCOPE)

find_package(Qt6 REQUIRED COMPONENTS Core Gui)
find_package(KF6Notifications 6.31.0 REQUIRED)

add_executable(knotifications_smoketest main.cpp)
ecm_mark_nongui_executable(knotifications_smoketest)
target_link_libraries(knotifications_smoketest PRIVATE Qt6::Core Qt6::Gui KF6::Notifications)

