cmake_minimum_required(VERSION 3.20)
project(gwenview_smoketest LANGUAGES CXX)

find_package(ECM 6.31.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(ECMMarkNonGuiExecutable)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets Svg Multimedia)
find_package(KF6 REQUIRED COMPONENTS KIO ItemModels I18n Parts WindowSystem IconThemes Notifications GuiAddons WidgetsAddons Crash)
find_package(JPEG REQUIRED)
find_package(PNG REQUIRED)
find_package(TIFF REQUIRED)
find_package(exiv2 REQUIRED CONFIG)

add_executable(gwenview_smoketest main.cpp)
ecm_mark_nongui_executable(gwenview_smoketest)
target_link_libraries(gwenview_smoketest PRIVATE
    Qt6::Core Qt6::Gui Qt6::Widgets Qt6::Svg Qt6::Multimedia
    KF6::KIOCore KF6::ItemModels KF6::I18n KF6::Parts KF6::WindowSystem
    KF6::IconThemes KF6::Notifications KF6::GuiAddons KF6::WidgetsAddons KF6::Crash
    JPEG::JPEG PNG::PNG TIFF::TIFF Exiv2::exiv2lib
)

