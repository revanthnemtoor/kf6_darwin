#include <QApplication>
#include <KIconLoader>
#include <iostream>

int main(int argc, char **argv) {
    qputenv("QT_QPA_PLATFORM", "offscreen");
    QApplication app(argc, argv);
    KIconLoader *loader = KIconLoader::global();
    if (!loader) return 1;
    std::cout << "KF6::IconThemes smoke test passed" << std::endl;
    return 0;
}

