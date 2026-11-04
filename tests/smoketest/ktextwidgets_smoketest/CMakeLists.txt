cmake_minimum_required(VERSION 3.20)
project(ktextwidgets_smoketest LANGUAGES CXX)

find_package(ECM 6.31.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(ECMMarkNonGuiExecutable)
include(KDECompilerSettings NO_POLICY_SCOPE)

find_package(Qt6 REQUIRED COMPONENTS Core Widgets)
find_package(KF6TextWidgets 6.31.0 REQUIRED)

add_executable(ktextwidgets_smoketest main.cpp)
ecm_mark_nongui_executable(ktextwidgets_smoketest)
target_link_libraries(ktextwidgets_smoketest PRIVATE Qt6::Core Qt6::Widgets KF6::TextWidgets)

