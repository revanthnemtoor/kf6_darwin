#include <cstdio>
#include <cstring>
#include "ecm_smoketest_version.h"

int main() {
    std::printf("ECM Smoke Test\n");
    std::printf("  ECM_VERSION              = %s\n", EXPECTED_ECM_VERSION);
    std::printf("  GENERATED_VERSION_STRING = %s\n", ECM_SMOKETEST_VERSION_STRING);
    std::printf("  KDE_INSTALL_FULL_LIBDIR  = %s\n", EXPECTED_KDE_LIBDIR);
    std::printf("  KDE_INSTALL_FULL_BUNDLE  = %s\n", EXPECTED_KDE_BUNDLEDIR);

    if (std::strcmp(EXPECTED_ECM_VERSION, "6.31.0") != 0) {
        std::fprintf(stderr, "FAIL: Expected ECM_VERSION 6.31.0, got %s\n", EXPECTED_ECM_VERSION);
        return 1;
    }
    if (std::strcmp(ECM_SMOKETEST_VERSION_STRING, "1.2.3") != 0) {
        std::fprintf(stderr, "FAIL: Expected generated version 1.2.3, got %s\n", ECM_SMOKETEST_VERSION_STRING);
        return 1;
    }
    if (std::strcmp(EXPECTED_KDE_LIBDIR, "/opt/pacman/lib") != 0) {
        std::fprintf(stderr, "FAIL: Expected KDE_INSTALL_FULL_LIBDIR /opt/pacman/lib, got %s\n", EXPECTED_KDE_LIBDIR);
        return 1;
    }
    std::printf("PASS: All ECM CMake modules and generated headers verified.\n");
    return 0;
}

