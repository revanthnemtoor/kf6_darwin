#include <QApplication>
#include <KCompletion>
#include <iostream>

int main(int argc, char **argv) {
    qputenv("QT_QPA_PLATFORM", "offscreen");
    QApplication app(argc, argv);
    KCompletion comp;
    comp.insertItems({QStringLiteral("darwin_x86_64"), QStringLiteral("darwin_arm64")});
    const QString match = comp.makeCompletion(QStringLiteral("darwin_x"));
    if (match != QStringLiteral("darwin_x86_64")) return 1;
    std::cout << "KF6::Completion smoke test passed: " << match.toStdString() << std::endl;
    return 0;
}

