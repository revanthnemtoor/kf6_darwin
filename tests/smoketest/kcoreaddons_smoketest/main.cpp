#include <QCoreApplication>
#include <KAboutData>
#include <KFormat>
#include <KStringHandler>
#include <kcoreaddons_version.h>
#include <cstdio>

int main(int argc, char **argv) {
    QCoreApplication app(argc, argv);

    KAboutData about(
        QStringLiteral("kcoreaddons_smoketest"),
        QStringLiteral("KCoreAddons Darwin Smoke Test"),
        QStringLiteral(KCOREADDONS_VERSION_STRING),
        QStringLiteral("Validates KF6::CoreAddons on Darwin"),
        KAboutLicense::LGPL_V2_1
    );
    KAboutData::setApplicationData(about);

    KFormat fmt;
    const QString formattedSize = fmt.formatByteSize(1024 * 1024);
    const QString squeezed = KStringHandler::csqueeze(QStringLiteral("HelloFromKF6CoreAddonsOnDarwin"), 15);

    std::printf("KCoreAddons Smoke Test\n");
    std::printf("  Version       : %s\n", KCOREADDONS_VERSION_STRING);
    std::printf("  ComponentName : %s\n", qPrintable(KAboutData::applicationData().componentName()));
    std::printf("  FormatByteSize: %s\n", qPrintable(formattedSize));
    std::printf("  CSqueeze      : %s\n", qPrintable(squeezed));

    if (KAboutData::applicationData().version() != QStringLiteral("6.31.0")) {
        std::fprintf(stderr, "FAIL: unexpected KCoreAddons version\n");
        return 1;
    }
    if (formattedSize.isEmpty() || squeezed.isEmpty()) {
        std::fprintf(stderr, "FAIL: unexpected empty formatted output\n");
        return 1;
    }

    std::printf("PASS: KF6::CoreAddons runtime test succeeded.\n");
    return 0;
}

