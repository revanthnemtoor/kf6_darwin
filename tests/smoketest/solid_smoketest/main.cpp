#include <QCoreApplication>
#include <Solid/Device>
#include <solid_version.h>
#include <cstdio>

int main(int argc, char **argv) {
    QCoreApplication app(argc, argv);

    const QList<Solid::Device> devices = Solid::Device::allDevices();

    std::printf("Solid Smoke Test\n");
    std::printf("  Version      : %s\n", SOLID_VERSION_STRING);
    std::printf("  Device Count : %lld (via native IOKit backend)\n", static_cast<long long>(devices.size()));

    if (devices.isEmpty()) {
        std::fprintf(stderr, "FAIL: Solid::Device::allDevices() returned 0 devices on Darwin IOKit backend\n");
        return 1;
    }

    std::printf("PASS: KF6::Solid native Darwin IOKit runtime test succeeded.\n");
    return 0;
}

