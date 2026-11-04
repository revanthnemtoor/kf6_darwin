#include <QApplication>
#include <KStandardAction>
#include <QAction>
#include <iostream>

int main(int argc, char **argv) {
    qputenv("QT_QPA_PLATFORM", "offscreen");
    QApplication app(argc, argv);
    QAction *act = KStandardAction::quit(&app, &QCoreApplication::quit, &app);
    if (!act || act->text().isEmpty()) return 1;
    std::cout << "KF6::ConfigWidgets smoke test passed: " << act->text().toStdString() << std::endl;
    return 0;
}

