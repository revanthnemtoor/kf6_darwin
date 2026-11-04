cmake_minimum_required(VERSION 3.20)
project(kjobwidgets_smoketest LANGUAGES CXX)

find_package(ECM 6.31.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(ECMMarkNonGuiExecutable)
include(KDECompilerSettings NO_POLICY_SCOPE)

find_package(Qt6 REQUIRED COMPONENTS Core Widgets)
find_package(KF6JobWidgets 6.31.0 REQUIRED)

add_executable(kjobwidgets_smoketest main.cpp)
ecm_mark_nongui_executable(kjobwidgets_smoketest)
target_link_libraries(kjobwidgets_smoketest PRIVATE Qt6::Core Qt6::Widgets KF6::JobWidgets)

