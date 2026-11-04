#include <QGuiApplication>
#include <KBookmark>
#include <iostream>

int main(int argc, char **argv) {
    qputenv("QT_QPA_PLATFORM", "offscreen");
    QGuiApplication app(argc, argv);
    KBookmark bm = KBookmark::standaloneBookmark(QStringLiteral("KDE"), QUrl(QStringLiteral("https://kde.org")), QStringLiteral("kde"));
    if (bm.url().toString() != QStringLiteral("https://kde.org")) return 1;
    std::cout << "KF6::Bookmarks smoke test passed: " << bm.url().toString().toStdString() << std::endl;
    return 0;
}

