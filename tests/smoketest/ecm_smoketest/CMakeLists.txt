cmake_minimum_required(VERSION 3.30)
project(ecm_smoketest VERSION 1.2.3 LANGUAGES CXX)

find_package(ECM 6.31.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs6)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(ECMSetupVersion)
include(ECMMarkNonGuiExecutable)

ecm_setup_version(PROJECT
    VARIABLE_PREFIX ECM_SMOKETEST
    VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/ecm_smoketest_version.h"
    PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/EcmSmoketestConfigVersion.cmake"
)

add_executable(ecm_smoketest main.cpp)
ecm_mark_nongui_executable(ecm_smoketest)

target_include_directories(ecm_smoketest PRIVATE "${CMAKE_CURRENT_BINARY_DIR}")
target_compile_definitions(ecm_smoketest PRIVATE
    EXPECTED_ECM_VERSION="${ECM_VERSION}"
    EXPECTED_KDE_LIBDIR="${KDE_INSTALL_FULL_LIBDIR}"
    EXPECTED_KDE_BUNDLEDIR="${KDE_INSTALL_FULL_BUNDLEDIR}"
)
