#include <QApplication>
#include <KTextEdit>
#include <iostream>

int main(int argc, char **argv) {
    qputenv("QT_QPA_PLATFORM", "offscreen");
    QApplication app(argc, argv);
    KTextEdit edit;
    edit.setPlainText(QStringLiteral("KF6 TextWidgets Darwin"));
    if (edit.toPlainText() != QStringLiteral("KF6 TextWidgets Darwin")) return 1;
    std::cout << "KF6::TextWidgets smoke test passed: " << edit.toPlainText().toStdString() << std::endl;
    return 0;
}

