#include <QApplication>
#include <KActionCollection>
#include <QAction>
#include <iostream>

int main(int argc, char **argv) {
    qputenv("QT_QPA_PLATFORM", "offscreen");
    QApplication app(argc, argv);
    KActionCollection coll(&app);
    QAction *act = coll.addAction(QStringLiteral("test_action"));
    if (!act || coll.action(QStringLiteral("test_action")) != act) return 1;
    std::cout << "KF6::XmlGui smoke test passed" << std::endl;
    return 0;
}

