#include <QGuiApplication>
#include <KColorScheme>
#include <iostream>

int main(int argc, char **argv) {
    qputenv("QT_QPA_PLATFORM", "offscreen");
    QGuiApplication app(argc, argv);
    KColorScheme scheme(QPalette::Active, KColorScheme::Window);
    if (!scheme.background().color().isValid()) return 1;
    std::cout << "KF6::ColorScheme smoke test passed: bg=" << scheme.background().color().name().toStdString() << std::endl;
    return 0;
}

