#include <QCoreApplication>
#include <KLocalizedString>
#include <KTimeZone>
#include <ki18n_version.h>
#include <cstdio>
#include <cstring>

int main(int argc, char **argv) {
    QCoreApplication app(argc, argv);
    KLocalizedString::setApplicationDomain("ki18n_smoketest");

    const QString msg = i18n("Welcome to %1 on %2", QStringLiteral("KF6 Darwin"), QStringLiteral("macOS"));
    const char *tz = KTimeZone::fromLocation(28.6139f, 77.2090f);

    std::printf("KI18n Smoke Test\n");
    std::printf("  Version  : %s\n", KI18N_VERSION_STRING);
    std::printf("  Message  : %s\n", qPrintable(msg));
    std::printf("  TimeZone : %s\n", tz ? tz : "null");

    if (msg != QStringLiteral("Welcome to KF6 Darwin on macOS") || !tz || std::strcmp(tz, "Asia/Kolkata") != 0) {
        std::fprintf(stderr, "FAIL: KI18n output mismatch\n");
        return 1;
    }

    std::printf("PASS: KF6::I18n and KF6::I18nLocaleData runtime test succeeded.\n");
    return 0;
}

