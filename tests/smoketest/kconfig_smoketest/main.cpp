#include <QCoreApplication>
#include <QTemporaryFile>
#include <KConfig>
#include <KConfigGroup>
#include <kconfig_version.h>
#include <cstdio>

int main(int argc, char **argv) {
    QCoreApplication app(argc, argv);

    QTemporaryFile tmpFile;
    if (!tmpFile.open()) {
        std::fprintf(stderr, "FAIL: Could not create temporary config file\n");
        return 1;
    }
    const QString cfgPath = tmpFile.fileName();
    tmpFile.close();

    {
        KConfig cfg(cfgPath, KConfig::SimpleConfig);
        KConfigGroup grp = cfg.group(QStringLiteral("DarwinTest"));
        grp.writeEntry("Framework", QStringLiteral("KConfig"));
        grp.writeEntry("Version", QStringLiteral(KCONFIG_VERSION_STRING));
        grp.writeEntry("Answer", 42);
        cfg.sync();
    }

    KConfig readCfg(cfgPath, KConfig::SimpleConfig);
    KConfigGroup readGrp = readCfg.group(QStringLiteral("DarwinTest"));
    const QString fw = readGrp.readEntry("Framework", QString());
    const int answer = readGrp.readEntry("Answer", 0);

    std::printf("KConfig Smoke Test\n");
    std::printf("  Version   : %s\n", KCONFIG_VERSION_STRING);
    std::printf("  Framework : %s\n", qPrintable(fw));
    std::printf("  Answer    : %d\n", answer);

    if (fw != QStringLiteral("KConfig") || answer != 42) {
        std::fprintf(stderr, "FAIL: KConfig round-trip mismatch\n");
        return 1;
    }

    std::printf("PASS: KF6::ConfigCore and KF6::ConfigGui runtime test succeeded.\n");
    return 0;
}

