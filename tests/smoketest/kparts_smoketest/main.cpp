#include <QApplication>
#include <KParts/OpenUrlArguments>
#include <iostream>

int main(int argc, char **argv) {
    qputenv("QT_QPA_PLATFORM", "offscreen");
    QApplication app(argc, argv);
    KParts::OpenUrlArguments args;
    args.setMimeType(QStringLiteral("image/png"));
    if (args.mimeType() != QStringLiteral("image/png")) return 1;
    std::cout << "KF6::Parts smoke test passed: " << args.mimeType().toStdString() << std::endl;
    return 0;
}

