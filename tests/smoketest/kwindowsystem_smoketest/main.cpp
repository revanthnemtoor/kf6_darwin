#include <QGuiApplication>
#include <KWindowSystem>
#include <kwindowsystem_version.h>
#include <cstdio>

int main(int argc, char **argv) {
    qputenv("QT_QPA_PLATFORM", "offscreen");
    QGuiApplication app(argc, argv);

    const auto platform = KWindowSystem::platform();
    const bool isX11 = KWindowSystem::isPlatformX11();
    const bool isWayland = KWindowSystem::isPlatformWayland();

    std::printf("KWindowSystem Smoke Test\n");
    std::printf("  Version   : %s\n", KWINDOWSYSTEM_VERSION_STRING);
    std::printf("  Platform  : %d (X11=%d, Wayland=%d)\n", static_cast<int>(platform), isX11 ? 1 : 0, isWayland ? 1 : 0);

    if (isX11 || isWayland) {
        std::fprintf(stderr, "FAIL: Darwin should not report X11 or Wayland\n");
        return 1;
    }

    std::printf("PASS: KF6::WindowSystem runtime test succeeded.\n");
    return 0;
}

