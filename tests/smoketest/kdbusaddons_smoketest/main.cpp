#include <QCoreApplication>
#include <KDBusService>
#include <kdbusaddons_version.h>
#include <cstdio>
#include <cstring>

int main(int argc, char **argv) {
    QCoreApplication app(argc, argv);

    std::printf("KDBusAddons Smoke Test\n");
    std::printf("  Version : %s\n", KDBUSADDONS_VERSION_STRING);

    if (std::strcmp(KDBUSADDONS_VERSION_STRING, "6.31.0") != 0) {
        std::fprintf(stderr, "FAIL: KDBusAddons version mismatch\n");
        return 1;
    }

    std::printf("PASS: KF6::DBusAddons linkage and header verification succeeded.\n");
    return 0;
}

