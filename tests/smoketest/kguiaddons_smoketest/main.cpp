#include <QGuiApplication>
#include <QColor>
#include <KColorUtils>
#include <kguiaddons_version.h>
#include <cstdio>

int main(int argc, char **argv) {
    qputenv("QT_QPA_PLATFORM", "offscreen");
    QGuiApplication app(argc, argv);

    const QColor c1(Qt::black);
    const QColor c2(Qt::white);
    const qreal ratio = KColorUtils::contrastRatio(c1, c2);
    const QColor mixed = KColorUtils::mix(c1, c2, 0.5);

    std::printf("KGuiAddons Smoke Test\n");
    std::printf("  Version       : %s\n", KGUIADDONS_VERSION_STRING);
    std::printf("  ContrastRatio : %.2f\n", ratio);
    std::printf("  MixedColor    : %s\n", qPrintable(mixed.name()));

    if (ratio < 20.0) {
        std::fprintf(stderr, "FAIL: unexpected contrast ratio %.2f\n", ratio);
        return 1;
    }

    std::printf("PASS: KF6::GuiAddons runtime test succeeded.\n");
    return 0;
}

