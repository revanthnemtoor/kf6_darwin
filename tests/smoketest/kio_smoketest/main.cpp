#include <QApplication>
#include <KIO/Global>
#include <iostream>

int main(int argc, char **argv) {
    qputenv("QT_QPA_PLATFORM", "offscreen");
    QApplication app(argc, argv);
    const QString sz = KIO::convertSize(1048576);
    if (sz.isEmpty()) return 1;
    std::cout << "KF6::KIO smoke test passed: 1048576 -> " << sz.toStdString() << std::endl;
    return 0;
}

