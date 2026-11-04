#include <QApplication>
#include <KGuiItem>
#include <KStandardGuiItem>
#include <KMessageWidget>
#include <kwidgetsaddons_version.h>
#include <cstdio>

int main(int argc, char **argv) {
    qputenv("QT_QPA_PLATFORM", "offscreen");
    QApplication app(argc, argv);

    KGuiItem okItem = KStandardGuiItem::ok();
    KMessageWidget msgWidget(QStringLiteral("KF6 WidgetsAddons Darwin Smoke Test"));
    msgWidget.setMessageType(KMessageWidget::Information);

    std::printf("KWidgetsAddons Smoke Test\n");
    std::printf("  Version     : %s\n", KWIDGETSADDONS_VERSION_STRING);
    std::printf("  OK GuiItem  : %s\n", qPrintable(okItem.text()));
    std::printf("  MessageText : %s\n", qPrintable(msgWidget.text()));

    if (msgWidget.text() != QStringLiteral("KF6 WidgetsAddons Darwin Smoke Test")) {
        std::fprintf(stderr, "FAIL: KMessageWidget text mismatch\n");
        return 1;
    }

    std::printf("PASS: KF6::WidgetsAddons runtime test succeeded.\n");
    return 0;
}

