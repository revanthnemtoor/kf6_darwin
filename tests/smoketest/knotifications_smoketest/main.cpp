#include <QGuiApplication>
#include <KNotification>
#include <iostream>

int main(int argc, char **argv) {
    qputenv("QT_QPA_PLATFORM", "offscreen");
    QGuiApplication app(argc, argv);
    KNotification notification(QStringLiteral("testEvent"));
    notification.setTitle(QStringLiteral("KF6 Darwin"));
    notification.setText(QStringLiteral("Smoke test notification"));
    if (notification.title() != QStringLiteral("KF6 Darwin")) return 1;
    std::cout << "KF6::Notifications smoke test passed: " << notification.title().toStdString() << std::endl;
    return 0;
}

