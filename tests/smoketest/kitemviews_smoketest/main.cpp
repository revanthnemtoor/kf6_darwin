#include <QApplication>
#include <KListWidgetSearchLine>
#include <kitemviews_version.h>
#include <cstdio>

int main(int argc, char **argv) {
    qputenv("QT_QPA_PLATFORM", "offscreen");
    QApplication app(argc, argv);

    KListWidgetSearchLine searchLine;
    searchLine.setPlaceholderText(QStringLiteral("Search Darwin items..."));

    std::printf("KItemViews Smoke Test\n");
    std::printf("  Version     : %s\n", KITEMVIEWS_VERSION_STRING);
    std::printf("  Placeholder : %s\n", qPrintable(searchLine.placeholderText()));

    if (searchLine.placeholderText() != QStringLiteral("Search Darwin items...")) {
        std::fprintf(stderr, "FAIL: KListWidgetSearchLine placeholder mismatch\n");
        return 1;
    }

    std::printf("PASS: KF6::ItemViews runtime test succeeded.\n");
    return 0;
}

