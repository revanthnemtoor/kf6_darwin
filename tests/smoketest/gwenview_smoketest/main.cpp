#include <QApplication>
#include <QProcess>
#include <exiv2/exiv2.hpp>
#include <png.h>
#include <tiffio.h>
#include <iostream>

int main(int argc, char **argv) {
    qputenv("QT_QPA_PLATFORM", "offscreen");
    QApplication app(argc, argv);

    const std::string exivVer = Exiv2::versionString();
    const char *pngVer = png_get_libpng_ver(nullptr);
    const char *tiffVer = TIFFGetVersion();
    if (exivVer.empty() || !pngVer || !tiffVer) {
        return 1;
    }

    QProcess proc;
    proc.start(QStringLiteral("/opt/pacman/Applications/KDE/gwenview.app/Contents/MacOS/gwenview"), {QStringLiteral("--version")});
    if (!proc.waitForFinished(10000) || proc.exitCode() != 0) {
        return 1;
    }
    const QString out = QString::fromUtf8(proc.readAllStandardOutput()).trimmed();
    if (!out.contains(QStringLiteral("gwenview 26.08.2"))) {
        return 1;
    }

    std::cout << "Gwenview stack smoke test passed: " << out.toStdString()
              << " (Exiv2=" << exivVer << ", libpng=" << pngVer << ")" << std::endl;
    return 0;
}

