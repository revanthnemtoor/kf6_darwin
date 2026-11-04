#include <QApplication>
#include <KDialogJobUiDelegate>
#include <iostream>

int main(int argc, char **argv) {
    qputenv("QT_QPA_PLATFORM", "offscreen");
    QApplication app(argc, argv);
    KDialogJobUiDelegate delegate;
    delegate.setAutoErrorHandlingEnabled(false);
    if (delegate.isAutoErrorHandlingEnabled()) return 1;
    std::cout << "KF6::JobWidgets smoke test passed" << std::endl;
    return 0;
}

